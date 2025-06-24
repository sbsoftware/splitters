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

  model_action :set_name, set_name_form do
    NAME_FIELD = "name"

    before do
      return 403 unless model.user_id == ctx.session.user_id

      true
    end

    controller do
      unless body = ctx.request.body
        ctx.response.status = :bad_request
        return
      end

      new_name = nil
      HTTP::Params.parse(body.gets_to_end) do |key, value|
        case key
        when NAME_FIELD
          new_name = value
        end
      end

      model.update(name: new_name) if new_name && new_name.size.positive?
    end

    view do
      css_class Container
      css_class Caption
      css_class Input
      css_class ButtonRow

      template do
        div Container do
          div Caption do
            "Sag' den anderen, wer du bist:"
          end
          form action: action.uri_path, method: "POST" do
            input Input, type: :text, name: NAME_FIELD, required: true
            div ButtonRow do
              button do
                "Speichern"
              end
            end
          end
        end
      end

      style do
        rule Container do
          margin 0.px, :auto
          padding 16.px
          max_width 600.px
          border 1.px, :solid, :silver
        end

        rule Caption do
          margin_bottom 8.px
        end

        rule Input do
          width 100.percent
        end

        rule ButtonRow do
          margin_top 16.px
          display :flex
          justify_content :flex_end
        end
      end
    end
  end

  model_template :set_name_form do
    set_name_action_template(ctx).to_html unless name
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

      model.update(weight: weight) if weight && weight.positive?
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
