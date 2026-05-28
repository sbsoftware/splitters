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
    css_class SettingsView

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
        user.update_paypal_username_action_template(ctx)
      end
    end

    style do
      rule SettingsView do
        padding 16.px
      end
    end
  end
end
