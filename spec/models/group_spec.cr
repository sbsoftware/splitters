require "../spec_helper"
require "crumble/spec/test_request_context"

module GroupSpec
  describe Group do
    it "creates offline members from existing group members and seeds template weights" do
      user = User.create
      group = Group.create(name: "Spec Group")
      WeightTemplate.create(group_id: group.id, name: "Standard")
      WeightTemplate.create(group_id: group.id, name: "Vacation")
      GroupMembership.create(group_id: group.id, user_id: user.id, name: "Anna")

      body = URI::Params.encode({Group::CreateOfflineMemberAction::NAME_FIELD => "  Ben  "})
      response_io = IO::Memory.new
      ctx = Crumble::Server::TestRequestContext.new(
        method: "POST",
        resource: Group::CreateOfflineMemberAction.uri_path(group.id.value),
        body: body,
        response_io: response_io
      )
      ctx.session.update!(user_id: user.id.value)

      Group::CreateOfflineMemberAction.handle(ctx).should be_true
      ctx.response.status_code.should eq(200)

      offline_membership = GroupMembership.where(group_id: group.id, name: "Ben").first.not_nil!
      offline_membership.user_id_value.should be_nil
      offline_membership.offline?.should be_true
      WeightTemplateMembership.where(group_membership_id: offline_membership.id).count.should eq(2)

      ctx.response.close
      response_io.to_s.includes?("data-model-template-id=\"Group##{group.id.value}-members_list_view\"").should be_true
    end

    it "shows the offline creation form and badge to group members" do
      user = User.create
      group = Group.create(name: "Spec Group")
      GroupMembership.create(group_id: group.id, user_id: user.id, name: "Anna")
      GroupMembership.create(group_id: group.id, name: "Ben")

      response_io = IO::Memory.new
      ctx = Crumble::Server::TestRequestContext.new(
        method: "GET",
        resource: GroupMembersPage.uri_path(group_id: group.id),
        response_io: response_io
      )
      ctx.session.update!(user_id: user.id.value)

      GroupMembersPage.handle(ctx).should be_true
      ctx.response.status_code.should eq(200)
      ctx.response.close
      html = response_io.to_s

      html.includes?(Group::CreateOfflineMemberAction.uri_path(group.id.value)).should be_true
      html.includes?("Offline").should be_true
      html.includes?("Ben").should be_true
    end

    it "rejects offline member creation from outsiders" do
      member_user = User.create
      outsider_user = User.create
      group = Group.create(name: "Spec Group")
      GroupMembership.create(group_id: group.id, user_id: member_user.id, name: "Anna")

      body = URI::Params.encode({Group::CreateOfflineMemberAction::NAME_FIELD => "Ben"})
      ctx = Crumble::Server::TestRequestContext.new(
        method: "POST",
        resource: Group::CreateOfflineMemberAction.uri_path(group.id.value),
        body: body
      )
      ctx.session.update!(user_id: outsider_user.id.value)

      Group::CreateOfflineMemberAction.handle(ctx).should be_true
      ctx.response.status_code.should eq(403)
      GroupMembership.where(group_id: group.id, name: "Ben").first?.should be_nil
    end
  end
end
