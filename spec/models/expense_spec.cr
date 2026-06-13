require "../spec_helper"
require "crumble/spec/test_request_context"

module ExpenseSpec
  describe Expense do
    it "shows card delete action only to users who can edit and requires confirmation" do
      payer_user = User.create
      other_user = User.create
      group = Group.create(name: "Spec Group")
      payer_membership = GroupMembership.create(group_id: group.id, user_id: payer_user.id, name: "Anna")
      GroupMembership.create(group_id: group.id, user_id: other_user.id, name: "Ben")

      expense = Expense.create(
        group_id: group.id,
        group_membership_id: payer_membership.id,
        weight_template_id: nil,
        description: "Snacks",
        amount: 1200
      )

      payer_ctx = Crumble::Server::TestRequestContext.new(method: "GET", resource: "/")
      payer_ctx.session.update!(user_id: payer_user.id.value)

      card_html = Expense::DeleteFromCardAction.new(payer_ctx, expense).action_template.to_html
      card_html.includes?("data-crumble--turbo--custom-action-trigger--action-trigger-confirm-prompt-value=\"Ausgabe wirklich löschen?\"").should be_true
      card_html.includes?(Expense::DeleteFromCardAction.uri_path(expense.id.value)).should be_true

      other_ctx = Crumble::Server::TestRequestContext.new(method: "GET", resource: "/")
      other_ctx.session.update!(user_id: other_user.id.value)

      Expense::DeleteFromCardAction.new(other_ctx, expense).action_template.to_html.should be_empty
    end

    it "renders expense cards with the shared heading style and delete icon" do
      payer_user = User.create
      other_user = User.create
      group = Group.create(name: "Spec Group")
      payer_membership = GroupMembership.create(group_id: group.id, user_id: payer_user.id, name: "Anna")
      GroupMembership.create(group_id: group.id, user_id: other_user.id, name: "Ben")

      expense = Expense.create(
        group_id: group.id,
        group_membership_id: payer_membership.id,
        weight_template_id: nil,
        description: "Snacks",
        amount: 1200
      )

      response_io = IO::Memory.new
      ctx = Crumble::Server::TestRequestContext.new(
        resource: GroupPage.uri_path(group_id: group.id),
        method: "GET",
        response_io: response_io
      )
      ctx.session.update!(user_id: payer_user.id.value)

      GroupPage.handle(ctx).should be_true
      ctx.response.status_code.should eq(200)
      ctx.response.close
      response_io.rewind
      body = response_io.to_s

      body.includes?(">Ausgabe<").should be_true
      body.includes?("12,00 €").should be_true
      body.includes?("Snacks").should be_true
      body.includes?("bezahlt von").should be_true
      body.includes?("Anna").should be_true
      body.includes?(ExpenseDetailsPage.uri_path(group.id, expense.id)).should be_true
      body.includes?(Expense::DeleteFromCardAction.uri_path(expense.id.value)).should be_true
      body.includes?(">delete<").should be_true
    end

    it "calculates member balances for a single equally weighted expense" do
      payer_user = User.create
      group = Group.create(name: "Spec Group")
      payer_membership = GroupMembership.create(group_id: group.id, user_id: payer_user.id, name: "Anna")
      member_2 = GroupMembership.create(group_id: group.id, name: "Ben")
      member_3 = GroupMembership.create(group_id: group.id, name: "Clara")
      member_4 = GroupMembership.create(group_id: group.id, name: "Dora")
      template = WeightTemplate.create(group_id: group.id, name: WeightTemplate::DEFAULT_NAME, membership_weight: 10)

      expense = Expense.create(
        group_id: group.id,
        group_membership_id: payer_membership.id,
        weight_template_id: template.id,
        description: "Dinner",
        amount: 10000
      )

      balances = expense.member_balances(group.group_memberships.to_a)
      balances[payer_membership.id.value].should eq(-7500)
      balances[member_2.id.value].should eq(2500)
      balances[member_3.id.value].should eq(2500)
      balances[member_4.id.value].should eq(2500)
    end

    it "deletes the expense for an authorized user and refreshes summary and card views" do
      payer_user = User.create
      other_user = User.create
      group = Group.create(name: "Spec Group")
      payer_membership = GroupMembership.create(group_id: group.id, user_id: payer_user.id, name: "Anna")
      GroupMembership.create(group_id: group.id, user_id: other_user.id, name: "Ben")

      expense = Expense.create(
        group_id: group.id,
        group_membership_id: payer_membership.id,
        weight_template_id: nil,
        description: "Snacks",
        amount: 1200
      )

      response_io = IO::Memory.new
      ctx = Crumble::Server::TestRequestContext.new(
        method: "POST",
        resource: Expense::DeleteFromCardAction.uri_path(expense.id.value),
        response_io: response_io
      )
      ctx.session.update!(user_id: payer_user.id.value)

      Expense::DeleteFromCardAction.handle(ctx).should be_true
      ctx.response.status_code.should eq(200)
      Expense.where(id: expense.id).first?.should be_nil

      ctx.response.close
      body = response_io.to_s
      body.includes?("data-model-template-id=\"Group##{group.id.value}-expenses_summary_view\"").should be_true
      body.includes?("data-model-template-id=\"Group##{group.id.value}-expenses_view\"").should be_true
    end

    it "rejects deletion from users without edit permission" do
      payer_user = User.create
      other_user = User.create
      group = Group.create(name: "Spec Group")
      payer_membership = GroupMembership.create(group_id: group.id, user_id: payer_user.id, name: "Anna")
      GroupMembership.create(group_id: group.id, user_id: other_user.id, name: "Ben")

      expense = Expense.create(
        group_id: group.id,
        group_membership_id: payer_membership.id,
        weight_template_id: nil,
        description: "Snacks",
        amount: 1200
      )

      response_io = IO::Memory.new
      ctx = Crumble::Server::TestRequestContext.new(
        method: "POST",
        resource: Expense::DeleteFromCardAction.uri_path(expense.id.value),
        response_io: response_io
      )
      ctx.session.update!(user_id: other_user.id.value)

      Expense::DeleteFromCardAction.handle(ctx).should be_true
      ctx.response.status_code.should eq(403)
      Expense.where(id: expense.id).first?.should_not be_nil

      ctx.response.close
      response_io.to_s.includes?("<turbo-stream").should be_false
    end

    it "creates an expense from submitted form values when a group has templates" do
      user = User.create
      group = Group.create(name: "Spec Group")
      membership = GroupMembership.create(group_id: group.id, user_id: user.id, name: "Anna")
      default_template = WeightTemplate.create(group_id: group.id, name: WeightTemplate::DEFAULT_NAME)
      WeightTemplate.create(group_id: group.id, name: "Vacation")

      body = URI::Params.encode({
        Group::CreateExpenseAction::DESCRIPTION_FIELD => "Snacks",
        Group::CreateExpenseAction::AMOUNT_FIELD      => "12.34",
      })
      ctx = Crumble::Server::TestRequestContext.new(
        method: "POST",
        resource: Group::CreateExpenseAction.uri_path(group.id.value),
        body: body
      )
      ctx.session.update!(user_id: user.id.value)

      Group::CreateExpenseAction.handle(ctx).should be_true
      ctx.response.status_code.should eq(201)

      expense = Expense.where(group_id: group.id).first.not_nil!
      expense.group_membership_id.value.should eq(membership.id.value)
      expense.description.value.should eq("Snacks")
      expense.amount.value.should eq(1234)
      expense.weight_template_id.try(&.value).should eq(default_template.id.value)
    end

    it "rejects creation when no weight template exists" do
      user = User.create
      group = Group.create(name: "Spec Group")
      GroupMembership.create(group_id: group.id, user_id: user.id, name: "Anna")

      body = URI::Params.encode({
        Group::CreateExpenseAction::DESCRIPTION_FIELD => "Snacks",
        Group::CreateExpenseAction::AMOUNT_FIELD      => "12.34",
      })
      ctx = Crumble::Server::TestRequestContext.new(
        method: "POST",
        resource: Group::CreateExpenseAction.uri_path(group.id.value),
        body: body
      )
      ctx.session.update!(user_id: user.id.value)

      Group::CreateExpenseAction.handle(ctx).should be_true
      ctx.response.status_code.should eq(422)
      Expense.where(group_id: group.id).count.should eq(0)
    end
  end
end
