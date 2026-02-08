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
  end
end
