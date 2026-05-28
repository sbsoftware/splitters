require "../spec_helper"
require "crumble/spec/test_request_context"

module SettingsPageSpec
  describe SettingsPage do
    it "renders a paypal user name field and is linked from the drawer" do
      user = User.create(paypal_username: "splitter")
      response_io = IO::Memory.new
      ctx = Crumble::Server::TestRequestContext.new(
        resource: SettingsPage.uri_path,
        method: "GET",
        response_io: response_io
      )
      ctx.session.update!(user_id: user.id.value)

      SettingsPage.handle(ctx).should be_true
      ctx.response.status_code.should eq(200)
      ctx.response.close
      response_io.rewind
      html = response_io.to_s

      html.includes?("Settings").should be_true
      html.includes?("PayPal user name").should be_true
      html.includes?("@").should be_true
      html.includes?("value=\"splitter\"").should be_true
      html.includes?("href=\"#{SettingsPage.uri_path}\"").should be_true
    end
  end
end
