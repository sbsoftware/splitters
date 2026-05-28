require "../spec_helper"
require "crumble/spec/test_request_context"

module SettingsResourceSpec
  describe SettingsResource do
    it "saves a normalized paypal user name for the current user" do
      user = User.create
      response_io = IO::Memory.new
      ctx = Crumble::Server::TestRequestContext.new(
        resource: SettingsResource.uri_path,
        method: "POST",
        body: URI::Params.encode({SettingsResource::PAYPAL_USERNAME_FIELD => "  @splitter  "}),
        response_io: response_io
      )
      ctx.session.update!(user_id: user.id.value)

      SettingsResource.handle(ctx).should be_true
      ctx.response.status_code.should eq(303)
      ctx.response.headers["Location"].should eq(SettingsPage.uri_path)
      User.find(user.id).paypal_username.should eq("splitter")
    end

    it "clears the paypal user name when the submitted value is blank" do
      user = User.create(paypal_username: "splitter")
      response_io = IO::Memory.new
      ctx = Crumble::Server::TestRequestContext.new(
        resource: SettingsResource.uri_path,
        method: "POST",
        body: URI::Params.encode({SettingsResource::PAYPAL_USERNAME_FIELD => "  "}),
        response_io: response_io
      )
      ctx.session.update!(user_id: user.id.value)

      SettingsResource.handle(ctx).should be_true
      ctx.response.status_code.should eq(303)
      User.find(user.id).paypal_username.should be_nil
    end
  end
end
