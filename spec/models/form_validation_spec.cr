require "../spec_helper"
require "crumble/spec/test_handler_context"

describe "model action form validation" do
  it "associates blank group names with the name field" do
    ctx = test_handler_context
    group = Group.new(id: 1_i64, name: "Group", created_at: Time.utc, updated_at: Time.utc)

    Group::CreateWeightTemplateAction::Form.new(ctx, group, name: " ").tap do |form|
      form.valid?.should be_false
      form.error_entries.should eq([{:name, "name"}])
    end

    Group::UpdateNameAction::Form.new(ctx, group, name: " ").tap do |form|
      form.valid?.should be_false
      form.error_entries.should eq([{:name, "name"}])
    end
  end

  it "associates blank membership names with the name field" do
    membership = GroupMembership.new(id: 1_i64, group_id: 1_i64, user_id: 1_i64)
    form = GroupMembership::UpdateNameAction::Form.new(test_handler_context, membership, name: " ")

    form.valid?.should be_false
    form.error_entries.should eq([{:name, "name"}])
  end
end
