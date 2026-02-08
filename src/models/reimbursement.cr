class Reimbursement < ApplicationRecord
  column group_id : Int64
  column payer_membership_id : Int64
  column recipient_membership_id : Int64
  column amount : Int32
  column created_at : Time
  column updated_at : Time

  css_class DeleteCardAction
  css_class DeleteCardButton
  css_class DeleteError

  def group
    Group.find(group_id)
  end

  def payer_membership
    GroupMembership.find(payer_membership_id)
  end

  def recipient_membership
    GroupMembership.find(recipient_membership_id)
  end

  model_action :delete_from_card, {group.expenses_view, group.expenses_summary_view} do
    @delete_error_message : String? = nil

    policy do
      can_submit do
        return false unless user_id = ctx.session.user_id

        model.payer_membership.user_id.value == user_id
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
        div DeleteCardAction do
          custom_action_trigger(confirm_prompt: "Rückerstattung wirklich löschen?").to_html do
            button DeleteCardButton, type: :button, title: "Rückerstattung löschen" do
              "x"
            end
          end
          if error_message = action.delete_error_message
            div DeleteError do
              error_message
            end
          end
        end
      end
    end
  end

  style do
    rule DeleteCardAction do
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

    rule DeleteCardButton do
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

    rule DeleteError do
      margin_top 6.px
      font_size 0.75.rem
      color "#a40000"
      text_align :right
    end
  end
end
