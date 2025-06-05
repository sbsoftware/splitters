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

    class Template
      getter uri_path : String

      def initialize(@uri_path); end

      css_class Container
      css_class Caption
      css_class Input
      css_class ButtonRow
      css_class Button

      ToHtml.instance_template do
        div Container do
          div Caption do
            "Sag' den anderen, wer du bist:"
          end
          form action: uri_path, method: "POST" do
            input Input, type: :text, name: NAME_FIELD, required: true
            div ButtonRow do
              button Button do
                "Speichern"
              end
            end
          end
        end
      end

      style do
        rule Container do
          prop("margin", "0px auto")
          padding 16.px
          maxWidth 600.px
          border 1.px, Solid, Silver
        end

        rule Caption do
          marginBottom 8.px
        end

        rule Input do
          width 100.percent
        end

        rule ButtonRow do
          marginTop 16.px
          display Flex
          justifyContent FlexEnd
        end

        rule Button do
          prop("border", "none")
          prop("outset", "none")
          backgroundColor "transparent"
        end
      end
    end

    def self.action_template(model)
      Template.new(uri_path(model.id))
    end
  end

  model_template :set_name_form do
    set_name_action_template.to_html unless name
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

    record Template, uri_path : String, group_membership : GroupMembership do
      css_class Hidden

      stimulus_controller UpdateController do
        targets :submit

        action :update do
          this.submitTarget.click._call
        end
      end

      ToHtml.instance_template do
        form UpdateController, action: uri_path, method: "POST" do
          input UpdateController.update_action("change"), type: :number, name: WEIGHT_FIELD, value: group_membership.weight / 10.0, step: "0.1"
          "x"
          button Hidden, UpdateController.submit_target
        end
      end

      style do
        rule Hidden do
          display None
        end
      end
    end

    def self.action_template(model)
      Template.new(uri_path(model.id), model)
    end
  end

  model_template :set_weight_form do
    set_weight_action_template.to_html
  end
end
