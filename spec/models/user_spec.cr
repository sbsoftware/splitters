require "../spec_helper"
require "crumble/spec/test_request_context"

module UserSpec
  describe User do
    it "saves a normalized paypal user name through the user model action" do
      user = User.create
      response_io = IO::Memory.new
      ctx = Crumble::Server::TestRequestContext.new(
        resource: User::UpdatePaypalUsernameAction.uri_path(user.id.value),
        method: "POST",
        body: URI::Params.encode({User::UpdatePaypalUsernameAction::PAYPAL_USERNAME_FIELD => "  @splitter  "}),
        response_io: response_io
      )
      ctx.session.update!(user_id: user.id.value)

      User::UpdatePaypalUsernameAction.handle(ctx).should be_true
      ctx.response.status_code.should eq(200)
      User.find(user.id).paypal_username.should eq("splitter")
    end

    it "clears the paypal user name when the submitted value is blank" do
      user = User.create(paypal_username: "splitter")
      response_io = IO::Memory.new
      ctx = Crumble::Server::TestRequestContext.new(
        resource: User::UpdatePaypalUsernameAction.uri_path(user.id.value),
        method: "POST",
        body: URI::Params.encode({User::UpdatePaypalUsernameAction::PAYPAL_USERNAME_FIELD => "  "}),
        response_io: response_io
      )
      ctx.session.update!(user_id: user.id.value)

      User::UpdatePaypalUsernameAction.handle(ctx).should be_true
      ctx.response.status_code.should eq(200)
      User.find(user.id).paypal_username.should be_nil
    end

    it "rejects paypal user name updates from other users" do
      user = User.create(paypal_username: "splitter")
      other_user = User.create
      response_io = IO::Memory.new
      ctx = Crumble::Server::TestRequestContext.new(
        resource: User::UpdatePaypalUsernameAction.uri_path(user.id.value),
        method: "POST",
        body: URI::Params.encode({User::UpdatePaypalUsernameAction::PAYPAL_USERNAME_FIELD => "intruder"}),
        response_io: response_io
      )
      ctx.session.update!(user_id: other_user.id.value)

      User::UpdatePaypalUsernameAction.handle(ctx).should be_true
      ctx.response.status_code.should eq(403)
      User.find(user.id).paypal_username.should eq("splitter")
    end
  end
end
