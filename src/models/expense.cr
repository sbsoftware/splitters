class Expense < ApplicationRecord
  column group_id : Int64
  column group_membership_id : Int64
  column weight_template_id : Int64?
  column description : String
  column amount : Int32
  column created_at : Time
  column updated_at : Time

  css_class ExpenseCard

  css_class ExpenseWeightTemplateLine
  css_class ExpenseWeightTemplateButtons
  css_class ExpenseWeightTemplateButton
  css_class ExpenseWeightTemplateButtonActive

  css_class ExpenseDeleteCardAction
  css_class ExpenseDeleteCardButton
  css_class ExpenseDeleteError

  style do
    rule ExpenseCard do
      position :relative
    end

    rule ExpenseWeightTemplateLine do
      display :flex
      align_items :center
      gap 8.px
      flex_wrap :wrap

      rule form do
        margin 0.px
      end
    end

    rule ExpenseWeightTemplateButtons do
      display :flex
      gap 6.px
      flex_wrap :wrap
    end

    rule ExpenseWeightTemplateButton do
      background_color :transparent
      border 1.px, :solid, "#111"
      border_radius 999.px
      padding 2.px, 10.px
      font_size 0.85.rem
      cursor :pointer
    end

    rule ExpenseWeightTemplateButtonActive do
      background_color "#cfe8ff"
    end

    rule ExpenseDeleteCardAction do
      position :absolute
      top 8.px
      right 8.px
      z_index 2
      display :flex
      flex_direction :column
      align_items :flex_end

      rule Crumble::Turbo::CustomActionTrigger::Outer, Crumble::Turbo::CustomActionTrigger::Inner do
        width :auto
        height :auto
      end
    end

    rule ExpenseDeleteCardButton do
      width 24.px
      height 24.px
      border 1.px, :solid, :black
      border_radius 999.px
      background_color :white
      cursor :pointer
      line_height 1
      padding 0.px
      font_size 0.9.rem
    end

    rule ExpenseDeleteError do
      margin_top 6.px
      font_size 0.75.rem
      color "#a40000"
      text_align :right
    end
  end

  def group
    Group.find(group_id)
  end

  def group_membership
    GroupMembership.find(group_membership_id)
  end

  def effective_weight_template_id(fallback_id : Int64?) : Int64?
    weight_template_id.try(&.value) || fallback_id
  end

  model_action :delete_from_card, {group.expenses_view, group.expenses_summary_view} do
    @delete_error_message : String? = nil

    policy do
      can_submit do
        return false unless user_id = ctx.session.user_id

        model.group_membership.user_id.value == user_id
      end

      can_view do
        can_submit?
      end
    end

    controller do
      begin
        model.destroy
      rescue Exception
        @delete_error_message = "Löschen fehlgeschlagen. Bitte erneut versuchen."
        ctx.response.status = :unprocessable_entity
      end
    end

    def delete_error_message : String?
      @delete_error_message
    end

    view do
      template do
        div ExpenseDeleteCardAction do
          custom_action_trigger(confirm_prompt: "Ausgabe wirklich löschen?").to_html do
            button ExpenseDeleteCardButton, type: :button, title: "Ausgabe löschen" do
              "x"
            end
          end
          if error_message = action.delete_error_message
            div ExpenseDeleteError do
              error_message
            end
          end
        end
      end
    end
  end

  model_action :set_weight_template, {group.expenses_view, group.expenses_summary_view} do
    TEMPLATE_FIELD = "weight_template_id"

    form do
      field weight_template_id : Int64, type: :hidden

      ToHtml.instance_template do
      end
    end

    before do
      return 403 unless user_id = ctx.session.user_id
      return 403 unless model.group.group_memberships.any? { |gm| gm.user_id == user_id }

      true
    end

    controller do
      unless body = ctx.request.body
        ctx.response.status = :bad_request
        return
      end

      form = begin
        Form.from_www_form(ctx, body.gets_to_end)
      rescue Exception
        ctx.response.status = :unprocessable_entity
        return
      end

      unless form.valid?
        ctx.response.status = :unprocessable_entity
        return
      end

      template_id = form.weight_template_id
      return unless template_id

      template = WeightTemplate.where(id: template_id, group_id: model.group_id).first?
      return unless template

      return if model.weight_template_id.try(&.value) == template.id.value

      model.update(weight_template_id: template.id)
    end

    view do
      template do
        group = model.group
        templates = group.weight_templates.order_by_id!.to_a
        default_template_id = group.default_weight_template.try(&.id.value) || templates.first?.try(&.id.value)
        current_template_id = model.effective_weight_template_id(default_template_id)

        action_form.to_html do
          div ExpenseWeightTemplateButtons do
            templates.each do |template|
              template_id = template.id.value
              button(
                ExpenseWeightTemplateButton,
                (ExpenseWeightTemplateButtonActive if current_template_id == template_id),
                type: :submit,
                name: TEMPLATE_FIELD,
                value: template_id
              ) do
                template.name
              end
            end
          end
        end
      end
    end
  end
end
