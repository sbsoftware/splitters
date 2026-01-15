require "../spec_helper"
require "crumble/spec/test_request_context"

describe GroupPage do
  it "renders the group page for a member" do
    user = User.create
    group = Group.create(name: "Test Group")
    GroupMembership.create(group_id: group.id, user_id: user.id, name: "Alex")

    response_io = IO::Memory.new
    ctx = Crumble::Server::TestRequestContext.new(
      resource: GroupPage.uri_path(group.id),
      method: "GET",
      response_io: response_io
    )
    ctx.session.update!(user_id: user.id.value)

    GroupPage.handle(ctx).should be_true
    ctx.response.status_code.should eq(200)
    ctx.response.close

    response_io.rewind
    body = response_io.to_s
    body.includes?("Test Group").should be_true
    body.includes?("Neue Ausgabe").should be_true
  end
end
