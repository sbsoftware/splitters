class SettingsPage < ApplicationPage
  root_path "/settings"

  before do
    unless ctx.session.user
      redirect HomePage.uri_path
      return 303
    end

    true
  end

  view do
    PAYPAL_USERNAME_FIELD = "paypal_username"

    css_class SettingsView
    css_class SettingsForm
    css_class SettingsField
    css_class SettingsLabel
    css_class PaypalInputRow
    css_class PaypalPrefix
    css_class PaypalInput
    css_class ButtonRow
    css_class SaveButton

    def user : User
      ctx.session.user.not_nil!
    end

    ToHtml.instance_template do
      Crumble::Material::TopAppBar.new(
        leading_icon: Crumble::Material::NavigationDrawer::MenuSwitch,
        headline: "Settings",
        trailing_icons: [] of Nil,
        type: :center_aligned
      )

      div SettingsView do
        form SettingsForm, action: SettingsResource.uri_path, method: "POST" do
          div SettingsField do
            label SettingsLabel, for: PAYPAL_USERNAME_FIELD do
              "PayPal user name"
            end
            div PaypalInputRow do
              span PaypalPrefix do
                "@"
              end
              input PaypalInput, id: PAYPAL_USERNAME_FIELD, type: :text, name: PAYPAL_USERNAME_FIELD, value: user.paypal_username.try(&.value).to_s, autocomplete: "username"
            end
          end
          div ButtonRow do
            button SaveButton, type: :submit do
              "Speichern"
            end
          end
        end
      end
    end

    style do
      rule SettingsView do
        padding 16.px
      end

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
