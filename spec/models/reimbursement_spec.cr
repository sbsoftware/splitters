require "../spec_helper"
require "crumble/spec/test_request_context"

module ReimbursementSpec
  describe Reimbursement do
    it "shows card delete action only to users who can edit and requires confirmation" do
      payer_user = User.create
      recipient_user = User.create
      group = Group.create(name: "Spec Group")
      payer_membership = GroupMembership.create(group_id: group.id, user_id: payer_user.id, name: "Anna")
      recipient_membership = GroupMembership.create(group_id: group.id, user_id: recipient_user.id, name: "Ben")
      reimbursement = Reimbursement.create(
        group_id: group.id,
        payer_membership_id: payer_membership.id,
        recipient_membership_id: recipient_membership.id,
        amount: 1200
      )

      payer_ctx = Crumble::Server::TestRequestContext.new(method: "GET", resource: "/")
      payer_ctx.session.update!(user_id: payer_user.id.value)

      card_html = Reimbursement::DeleteFromCardAction.new(payer_ctx, reimbursement).action_template.to_html
      card_html.includes?("window.confirm('Rückerstattung wirklich löschen?')").should be_true
      card_html.includes?(Reimbursement::DeleteFromCardAction.uri_path(reimbursement.id.value)).should be_true

      recipient_ctx = Crumble::Server::TestRequestContext.new(method: "GET", resource: "/")
      recipient_ctx.session.update!(user_id: recipient_user.id.value)

      Reimbursement::DeleteFromCardAction.new(recipient_ctx, reimbursement).action_template.to_html.should be_empty
    end

    it "deletes the reimbursement for an authorized user and refreshes summary and card views" do
      payer_user = User.create
      recipient_user = User.create
      group = Group.create(name: "Spec Group")
      payer_membership = GroupMembership.create(group_id: group.id, user_id: payer_user.id, name: "Anna")
      recipient_membership = GroupMembership.create(group_id: group.id, user_id: recipient_user.id, name: "Ben")
      reimbursement = Reimbursement.create(
        group_id: group.id,
        payer_membership_id: payer_membership.id,
        recipient_membership_id: recipient_membership.id,
        amount: 1200
      )

      response_io = IO::Memory.new
      ctx = Crumble::Server::TestRequestContext.new(
        method: "POST",
        resource: Reimbursement::DeleteFromCardAction.uri_path(reimbursement.id.value),
        response_io: response_io
      )
      ctx.session.update!(user_id: payer_user.id.value)

      Reimbursement::DeleteFromCardAction.handle(ctx).should be_true
      ctx.response.status_code.should eq(200)
      Reimbursement.where(id: reimbursement.id).first?.should be_nil

      ctx.response.close
      body = response_io.to_s
      body.includes?("data-model-template-id=\"Group##{group.id.value}-expenses_summary_view\"").should be_true
      body.includes?("data-model-template-id=\"Group##{group.id.value}-expenses_view\"").should be_true
    end

    it "rejects deletion from users without edit permission" do
      payer_user = User.create
      recipient_user = User.create
      group = Group.create(name: "Spec Group")
      payer_membership = GroupMembership.create(group_id: group.id, user_id: payer_user.id, name: "Anna")
      recipient_membership = GroupMembership.create(group_id: group.id, user_id: recipient_user.id, name: "Ben")
      reimbursement = Reimbursement.create(
        group_id: group.id,
        payer_membership_id: payer_membership.id,
        recipient_membership_id: recipient_membership.id,
        amount: 1200
      )

      response_io = IO::Memory.new
      ctx = Crumble::Server::TestRequestContext.new(
        method: "POST",
        resource: Reimbursement::DeleteFromCardAction.uri_path(reimbursement.id.value),
        response_io: response_io
      )
      ctx.session.update!(user_id: recipient_user.id.value)

      Reimbursement::DeleteFromCardAction.handle(ctx).should be_true
      ctx.response.status_code.should eq(403)
      Reimbursement.where(id: reimbursement.id).first?.should_not be_nil

      ctx.response.close
      response_io.to_s.includes?("<turbo-stream").should be_false
    end

    it "creates an exact-cent reimbursement from ausgleichen values" do
      debtor_user = User.create
      creditor_user = User.create
      group = Group.create(name: "Spec Group")
      debtor_membership = GroupMembership.create(group_id: group.id, user_id: debtor_user.id, name: "Anna")
      creditor_membership = GroupMembership.create(group_id: group.id, user_id: creditor_user.id, name: "Ben")

      Expense.create(
        group_id: group.id,
        group_membership_id: creditor_membership.id,
        weight_template_id: nil,
        description: "Snacks",
        amount: 58
      )

      debts = group.expense_debts([debtor_membership, creditor_membership])
      debts.size.should eq(1)
      debt = debts.first
      debt.debtor_id.should eq(debtor_membership.id.value)
      debt.creditor_id.should eq(creditor_membership.id.value)
      debt.amount_cents.should eq(29)

      body = URI::Params.encode({
        Group::CreateReimbursementAction::AMOUNT_FIELD    => group.amount_input_value(debt.amount_cents),
        Group::CreateReimbursementAction::RECIPIENT_FIELD => creditor_membership.id.value.to_s,
      })
      ctx = Crumble::Server::TestRequestContext.new(
        method: "POST",
        resource: Group::CreateReimbursementAction.uri_path(group.id.value),
        body: body
      )
      ctx.session.update!(user_id: debtor_user.id.value)

      Group::CreateReimbursementAction.handle(ctx).should be_true

      reimbursement = Reimbursement.where(group_id: group.id).first.not_nil!
      reimbursement.amount.value.should eq(29)
      group.expense_debts([debtor_membership, creditor_membership]).should eq([] of MinimumCashFlow::Debt)
    end
  end
end
