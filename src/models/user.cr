require "./application_record"
require "./group_membership"

class User < ApplicationRecord
  column name : String?
  column paypal_username : String?
  column created_at : Time
  column updated_at : Time

  has_many_of GroupMembership

  css_class SettingsForm
  css_class SettingsField
  css_class SettingsLabel
  css_class PaypalInputRow
  css_class PaypalPrefix
  css_class PaypalInput
  css_class ButtonRow
  css_class SaveButton

  def preferred_name : String?
    if current_name = name
      value = current_name.value
      return value unless value.empty?
    end

    memberships_with_names = group_memberships.to_a.select(&.name)
    membership = memberships_with_names.max_by?(&.id.value)
    membership.try(&.name).try(&.value)
  end

  model_action :update_paypal_username, nil do
    PAYPAL_USERNAME_FIELD = "paypal_username"

    form do
      field paypal_username : String? do
        before_render do |value|
          value || ctx.session.user.try(&.paypal_username).try(&.value)
        end

        after_submit do |value|
          stripped = value.try(&.strip).try(&.lchop("@")).try(&.strip)
          stripped.nil? || stripped.empty? ? nil : stripped
        end
      end

      ToHtml.instance_template do
        div ::User::SettingsField do
          label ::User::SettingsLabel, for: PAYPAL_USERNAME_FIELD do
            "PayPal user name"
          end
          div ::User::PaypalInputRow do
            span ::User::PaypalPrefix do
              "@"
            end
            input ::User::PaypalInput, id: PAYPAL_USERNAME_FIELD, type: :text, name: PAYPAL_USERNAME_FIELD, value: __apply_before_render_paypal_username(paypal_username).to_s, autocomplete: "username"
          end
        end
      end
    end

    policy do
      can_view do
        ctx.session.user_id == model.id.value
      end

      can_submit do
        ctx.session.user_id == model.id.value
      end
    end

    controller do
      model.update(**form.values) if form.valid?
    end

    view do
      template do
        div SettingsForm do
          action_form.to_html do
            div ButtonRow do
              button SaveButton, type: :submit do
                "Speichern"
              end
            end
          end
        end
      end

      style do
        rule SettingsForm do
          max_width 800.px
          margin 0.px, :auto
          padding 16.px
          border 1.px, :solid, :silver
          box_sizing :border_box
        end

        rule SettingsField do
          display :flex
          flex_direction :column
          gap 6.px
        end

        rule SettingsLabel do
          font_weight :bold
        end

        rule PaypalInputRow do
          display :flex
          align_items :stretch
        end

        rule PaypalPrefix do
          display :flex
          align_items :center
          padding 8.px, 10.px
          border 1.px, :solid, :black
          border_right :none
          background_color "#EEE"
          box_sizing :border_box
        end

        rule PaypalInput do
          flex_grow 1
          min_width 0.px
        end

        rule ButtonRow do
          margin_top 16.px
          display :flex
          justify_content :flex_end
        end

        rule SaveButton do
          padding 8.px, 14.px
          border 1.px, :solid, :black
          background_color :white
          cursor :pointer
        end
      end
    end
  end
end
