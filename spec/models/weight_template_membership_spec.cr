require "../spec_helper"
require "crumble/spec/test_request_context"

module WeightTemplateMembershipSpec
  describe WeightTemplateMembership do
    it "updates weights via the action controller" do
      user = User.create
      group = Group.create(name: "Spec Group")
      WeightTemplate.create(group_id: group.id, name: WeightTemplate::DEFAULT_NAME)
      membership = GroupMembership.create(group_id: group.id, user_id: user.id, name: "Alex")
      template = group.default_weight_template.not_nil!
      template_membership = WeightTemplateMembership.where(weight_template_id: template.id, group_membership_id: membership.id).first.not_nil!

      body = URI::Params.encode({"weight" => "1.5"})
      ctx = Crumble::Server::TestRequestContext.new(
        method: "POST",
        resource: WeightTemplateMembership::SetWeightAction.uri_path(template_membership.id),
        body: body
      )

      WeightTemplateMembership::SetWeightAction.handle(ctx).should be_true

      WeightTemplateMembership.find(template_membership.id).weight.value.should eq(15)
      GroupMembership.find(membership.id).weight.value.should eq(15)
    end
  end
end
