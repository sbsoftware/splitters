require "../spec_helper"
require "crumble/spec/test_request_context"

describe GroupPage do
  it "renders the group page for a member" do
    user = User.create
    group = Group.create(name: "Test Group")
    GroupMembership.create(group_id: group.id, user_id: user.id, name: "Alex")

    response_io = IO::Memory.new
    ctx = Crumble::Server::TestRequestContext.new(
      resource: GroupPage.uri_path(group_id: group.id),
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

  it "renders English field labels when Accept-Language prefers English" do
    user = User.create
    group = Group.create(name: "Test Group")
    GroupMembership.create(group_id: group.id, user_id: user.id, name: "Alex")

    response_io = IO::Memory.new
    ctx = Crumble::Server::TestRequestContext.new(
      resource: GroupPage.uri_path(group_id: group.id),
      method: "GET",
      headers: HTTP::Headers{"Accept-Language" => "en-US,en;q=0.9"},
      response_io: response_io
    )
    ctx.session.update!(user_id: user.id.value)

    GroupPage.handle(ctx).should be_true
    ctx.response.status_code.should eq(200)
    ctx.response.close

    response_io.rewind
    body = response_io.to_s
    body.includes?("Description:").should be_true
    body.includes?("Amount in €:").should be_true
    body.includes?("To:").should be_true
    body.includes?("Please choose").should be_true
  end

  it "renders German field labels when Accept-Language prefers German" do
    user = User.create
    group = Group.create(name: "Test Group")
    GroupMembership.create(group_id: group.id, user_id: user.id, name: "Alex")

    response_io = IO::Memory.new
    ctx = Crumble::Server::TestRequestContext.new(
      resource: GroupPage.uri_path(group_id: group.id),
      method: "GET",
      headers: HTTP::Headers{"Accept-Language" => "de-DE,de;q=0.9"},
      response_io: response_io
    )
    ctx.session.update!(user_id: user.id.value)

    GroupPage.handle(ctx).should be_true
    ctx.response.status_code.should eq(200)
    ctx.response.close

    response_io.rewind
    body = response_io.to_s
    body.includes?("Beschreibung:").should be_true
    body.includes?("Betrag in €:").should be_true
    body.includes?("An:").should be_true
    body.includes?("Bitte auswählen").should be_true
  end
end
