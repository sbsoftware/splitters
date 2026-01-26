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
end
