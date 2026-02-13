require "../spec_helper"
require "crumble/spec/test_request_context"

module GroupMembershipSpec
  describe GroupMembership do
    it "shows remove action to group members and hides it from non-members" do
      remover_user = User.create
      target_user = User.create
      outsider_user = User.create
      group = Group.create(name: "Spec Group")
      GroupMembership.create(group_id: group.id, user_id: remover_user.id, name: "Anna")
      target_membership = GroupMembership.create(group_id: group.id, user_id: target_user.id, name: "Ben")

      remover_ctx = Crumble::Server::TestRequestContext.new(method: "GET", resource: "/")
      remover_ctx.session.update!(user_id: remover_user.id.value)

      action_html = GroupMembership::RemoveFromGroupAction.new(remover_ctx, target_membership).action_template.to_html
      action_html.includes?(GroupMembership::RemoveFromGroupAction.uri_path(target_membership.id.value)).should be_true

      outsider_ctx = Crumble::Server::TestRequestContext.new(method: "GET", resource: "/")
      outsider_ctx.session.update!(user_id: outsider_user.id.value)

      GroupMembership::RemoveFromGroupAction.new(outsider_ctx, target_membership).action_template.to_html.should be_empty
    end

    it "removes a member and their template weights when they have no expenses" do
      remover_user = User.create
      target_user = User.create
      group = Group.create(name: "Spec Group")
      WeightTemplate.create(group_id: group.id, name: "Standard")
      WeightTemplate.create(group_id: group.id, name: "Vacation")

      GroupMembership.create(group_id: group.id, user_id: remover_user.id, name: "Anna")
      target_membership = GroupMembership.create(group_id: group.id, user_id: target_user.id, name: "Ben")

      WeightTemplateMembership.where(group_membership_id: target_membership.id).count.should eq(2)

      response_io = IO::Memory.new
      ctx = Crumble::Server::TestRequestContext.new(
        method: "POST",
        resource: GroupMembership::RemoveFromGroupAction.uri_path(target_membership.id.value),
        response_io: response_io
      )
      ctx.session.update!(user_id: remover_user.id.value)

      GroupMembership::RemoveFromGroupAction.handle(ctx).should be_true
      ctx.response.status_code.should eq(200)
      GroupMembership.where(id: target_membership.id).first?.should be_nil
      WeightTemplateMembership.where(group_membership_id: target_membership.id).first?.should be_nil

      ctx.response.close
      body = response_io.to_s
      body.includes?("data-model-template-id=\"Group##{group.id.value}-members_list_view\"").should be_true
    end

    it "blocks removal when the member has expenses and shows a clear error message" do
      remover_user = User.create
      target_user = User.create
      group = Group.create(name: "Spec Group")
      template = WeightTemplate.create(group_id: group.id, name: "Standard")

      GroupMembership.create(group_id: group.id, user_id: remover_user.id, name: "Anna")
      target_membership = GroupMembership.create(group_id: group.id, user_id: target_user.id, name: "Ben")

      Expense.create(
        group_id: group.id,
        group_membership_id: target_membership.id,
        weight_template_id: template.id,
        description: "Snacks",
        amount: 1200
      )

      response_io = IO::Memory.new
      ctx = Crumble::Server::TestRequestContext.new(
        method: "POST",
        resource: GroupMembership::RemoveFromGroupAction.uri_path(target_membership.id.value),
        response_io: response_io
      )
      ctx.session.update!(user_id: remover_user.id.value)

      GroupMembership::RemoveFromGroupAction.handle(ctx).should be_true
      ctx.response.status_code.should eq(422)
      GroupMembership.where(id: target_membership.id).first?.should_not be_nil
      WeightTemplateMembership.where(group_membership_id: target_membership.id).count.should eq(1)

      ctx.response.close
      response_io.to_s.includes?("Dieses Mitglied kann nicht entfernt werden, weil bereits Ausgaben erfasst wurden.").should be_true
    end

    it "redirects to home when a member removes themselves" do
      user = User.create
      group = Group.create(name: "Spec Group")
      WeightTemplate.create(group_id: group.id, name: "Standard")
      membership = GroupMembership.create(group_id: group.id, user_id: user.id, name: "Anna")

      response_io = IO::Memory.new
      ctx = Crumble::Server::TestRequestContext.new(
        method: "POST",
        resource: GroupMembership::RemoveFromGroupAction.uri_path(membership.id.value),
        response_io: response_io
      )
      ctx.session.update!(user_id: user.id.value)

      GroupMembership::RemoveFromGroupAction.handle(ctx).should be_true
      ctx.response.status_code.should eq(303)
      ctx.response.headers["Location"]?.should eq(HomePage.uri_path)
      GroupMembership.where(id: membership.id).first?.should be_nil
      WeightTemplateMembership.where(group_membership_id: membership.id).first?.should be_nil
    end
  end
end
