require "./application_record"
require "./group"

class GroupMembership < ApplicationRecord
  column group_id : Int64
  column user_id : Int64
  column name : String?
  column weight : Int32 = 10

  def group
    Group.find(group_id)
  end

  def display_name : String
    if current_name = name
      current_name.value
    else
      "Anonym"
    end
  end

  css_class NamePrompt
  css_class NameFormContainer

  model_template :name_display do
    if current_name = name
      current_name.value
    else
      i { "Anonym" }
    end
  end

  model_template :name_prompt_box do
    unless name
      div NameFormContainer do
        div NamePrompt do
          "Sag' den anderen, wer du bist:"
        end
        update_name_action_template(ctx)
      end
    end
  end

  model_action :update_name, name_display do
    css_class NameForm
    css_class ForceVisible
    css_class NameFormRow
    css_class NameInput
    css_class ButtonRow
    css_class ErrorMessage

    form do
      field name : String

      def valid?
        super

        errors = @errors.not_nil!
        if (value = name) && value.strip.empty?
          errors << "name"
        end

        errors.none?
      end

      def normalized_name : String?
        name.try(&.strip)
      end

      ToHtml.instance_template do
        div NameFormRow do
          input NameInput, type: :text, name: "name", value: name.to_s, required: true
        end
      end
    end

    @submitted_form : Form? = nil

    def form
      @submitted_form || Form.new(name: model.name.try(&.value) || "")
    end

    def editable? : Bool
      ctx.session.user_id == model.user_id.value
    end

    before do
      return 403 unless editable?

      true
    end

    controller do
      unless body = ctx.request.body
        ctx.response.status = :bad_request
        return
      end

      @submitted_form = Form.from_www_form(body.gets_to_end)
      form = @submitted_form.not_nil!

      unless form.valid?
        ctx.response.status = :unprocessable_entity
        return
      end

      new_name = form.normalized_name
      return unless new_name

      model.update(name: new_name)
      User.find(model.user_id).update(name: new_name)
      model.name_prompt_box.refresh!
    end

    view do
      template do
        errors = action.form.errors

        form NameForm, (ForceVisible if errors && errors.any?), action: action.uri_path, method: "POST" do
          action.form.to_html
          if errors
            if errors.includes?("name")
              div ErrorMessage do
                "Bitte gib einen Namen ein."
              end
            end
          end
          div ButtonRow do
            button do
              "Speichern"
            end
          end
        end
      end

      style do
        rule NameForm do
          margin_top 8.px
          padding 12.px, 12.px, 12.px, 32.px
        end

        # Many selector elements for higher specificity to achieve rule precedence
        rule form && NameForm && ForceVisible do
          display :block
        end

        rule NameFormRow do
          display :flex
        end

        rule NameInput do
          width 100.percent
        end

        rule ButtonRow do
          margin_top 8.px
          display :flex
          justify_content :flex_end

          rule button do
            padding 8.px, 14.px
          end
        end

        rule ErrorMessage do
          margin_bottom 8.px
        end
      end
    end
  end

  style do
    rule NameFormContainer do
      margin 0.px, :auto
      padding 16.px
      max_width 600.px
      border 1.px, :solid, :silver
    end

    rule NamePrompt do
      margin_bottom 8.px
    end
  end

  model_action :set_weight, set_weight_form do
    WEIGHT_FIELD = "weight"

    controller do
      unless body = ctx.request.body
        ctx.response.status = :bad_request
        return
      end

      weight = nil
      HTTP::Params.parse(body.gets_to_end) do |key, value|
        case key
        when WEIGHT_FIELD
          weight = (value.to_f * 10).to_i
        end
      rescue Exception
        weight = nil
      end

      if weight && weight.positive?
        model.update(weight: weight)
        model.group.expenses_summary_view.refresh!
      end
    end

    view do
      css_class Hidden

      stimulus_controller UpdateController do
        targets :submit

        action :update do
          this.submitTarget.click._call
        end
      end

      template do
        form UpdateController, action: action.uri_path, method: "POST" do
          input UpdateController.update_action("change"), type: :number, name: WEIGHT_FIELD, value: model.weight / 10.0, step: "0.1"
          "x"
          button Hidden, UpdateController.submit_target
        end
      end

      style do
        rule Hidden do
          display :none
        end
      end
    end
  end

  model_template :set_weight_form do
    set_weight_action_template(ctx).to_html
  end
end
