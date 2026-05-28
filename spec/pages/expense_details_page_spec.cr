require "../spec_helper"
require "crumble/spec/test_request_context"

describe ExpenseDetailsPage do
  it "renders expense details and member balances for group members" do
    payer_user = User.create
    group = Group.create(name: "Spec Group")
    payer_membership = GroupMembership.create(group_id: group.id, user_id: payer_user.id, name: "Anna")
    GroupMembership.create(group_id: group.id, name: "Ben")
    GroupMembership.create(group_id: group.id, name: "Clara")
    GroupMembership.create(group_id: group.id, name: "Dora")
    template = WeightTemplate.create(group_id: group.id, name: WeightTemplate::DEFAULT_NAME, membership_weight: 10)

    expense = Expense.create(
      group_id: group.id,
      group_membership_id: payer_membership.id,
      weight_template_id: template.id,
      description: "Dinner",
      amount: 10000
    )

    response_io = IO::Memory.new
    ctx = Crumble::Server::TestRequestContext.new(
      resource: ExpenseDetailsPage.uri_path(group.id, expense.id),
      method: "GET",
      response_io: response_io
    )
    ctx.session.update!(user_id: payer_user.id.value)

    ExpenseDetailsPage.handle(ctx).should be_true
    ctx.response.status_code.should eq(200)
    ctx.response.close

    response_io.rewind
    body = response_io.to_s
    body.includes?("100,00 €").should be_true
    body.includes?("Dinner").should be_true
    body.includes?("bezahlt von").should be_true
    body.includes?("Anna").should be_true
    body.includes?(WeightTemplate::DEFAULT_NAME).should be_true
    body.includes?("-75,00 €").should be_true
    body.includes?("25,00 €").should be_true
    body.includes?("Ben").should be_true
    body.includes?("Clara").should be_true
    body.includes?("Dora").should be_true
  end

  it "redirects non-members away from expense details" do
    payer_user = User.create
    other_user = User.create
    group = Group.create(name: "Spec Group")
    payer_membership = GroupMembership.create(group_id: group.id, user_id: payer_user.id, name: "Anna")
    template = WeightTemplate.create(group_id: group.id, name: WeightTemplate::DEFAULT_NAME)
    expense = Expense.create(group_id: group.id, group_membership_id: payer_membership.id, weight_template_id: template.id, description: "Dinner", amount: 10000)

    ctx = Crumble::Server::TestRequestContext.new(
      resource: ExpenseDetailsPage.uri_path(group.id, expense.id),
      method: "GET"
    )
    ctx.session.update!(user_id: other_user.id.value)

    ExpenseDetailsPage.handle(ctx).should be_true
    ctx.response.status_code.should eq(303)
    ctx.response.headers["Location"].should eq(HomePage.uri_path)
  end
end
