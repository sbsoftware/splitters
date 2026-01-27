require "./application_record"
require "./group_membership"
require "./weight_template"

class WeightTemplateMembership < ApplicationRecord
  column weight_template_id : Int64
  column group_membership_id : Int64
  column weight : Int32 = 10

  def weight_template
    WeightTemplate.find(weight_template_id)
  end

  def group_membership
    GroupMembership.find(group_membership_id)
  end

  def group
    weight_template.group
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

      return unless weight_value = weight
      return if weight_value < 0

      WeightTemplateMembership.transaction do
        model.update(weight: weight_value)
        if model.weight_template.default_template?
          model.group_membership.update(weight: weight_value)
        end
      end

      model.group.expenses_summary_view.refresh!
      model.group.expenses_view.refresh!
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
