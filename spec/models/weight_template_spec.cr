require "../spec_helper"

describe WeightTemplate do
  it "sets timestamps and seeds memberships on create" do
    user = User.create
    group = Group.create(name: "Spec Group")
    GroupMembership.create(group_id: group.id, user_id: user.id, name: "Alex")

    template = WeightTemplate.create(group_id: group.id, name: "Standard")

    template.created_at.value.should be_a(Time)
    template.updated_at.value.should be_a(Time)
    template.weight_template_memberships.count.should eq(1)
  end

  it "can seed memberships with default weights" do
    user = User.create
    group = Group.create(name: "Spec Group")
    membership = GroupMembership.create(group_id: group.id, user_id: user.id, name: "Alex", weight: 25)

    template = WeightTemplate.create(
      membership_weight: WeightTemplate::DEFAULT_WEIGHT,
      group_id: group.id,
      name: "Neues Template"
    )

    template_membership = WeightTemplateMembership.where(
      weight_template_id: template.id,
      group_membership_id: membership.id
    ).first.not_nil!

    template_membership.weight.value.should eq(WeightTemplate::DEFAULT_WEIGHT)
  end
end
