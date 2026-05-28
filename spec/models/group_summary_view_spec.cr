require "../spec_helper"
require "crumble/spec/test_request_context"

module GroupSummaryViewSpec
  describe Group do
    it "renders the empty summary state when there are no ledger entries" do
      user = User.create
      group = Group.create(name: "Spec Group")
      GroupMembership.create(group_id: group.id, user_id: user.id, name: "Anna")

      response_io = IO::Memory.new
      ctx = Crumble::Server::TestRequestContext.new(
        resource: GroupPage.uri_path(group_id: group.id),
        method: "GET",
        response_io: response_io
      )
      ctx.session.update!(user_id: user.id.value)
      GroupPage.handle(ctx).should be_true
      ctx.response.status_code.should eq(200)
      ctx.response.close
      response_io.rewind
      html = response_io.to_s

      html.includes?("Summe aller Ausgaben: 0,00 €").should be_true
      html.includes?("Noch keine Ausgaben.").should be_true
      html.includes?("Alle sind ausgeglichen.").should be_false
      html.includes?("Bezahlt!").should be_false
    end

    it "renders the settled state when debts are fully reimbursed" do
      payer_user = User.create
      recipient_user = User.create
      group = Group.create(name: "Spec Group")
      payer_membership = GroupMembership.create(group_id: group.id, user_id: payer_user.id, name: "Anna")
      recipient_membership = GroupMembership.create(group_id: group.id, user_id: recipient_user.id, name: "Ben")

      Expense.create(
        group_id: group.id,
        group_membership_id: recipient_membership.id,
        weight_template_id: nil,
        description: "Dinner",
        amount: 1200
      )
      Reimbursement.create(
        group_id: group.id,
        payer_membership_id: payer_membership.id,
        recipient_membership_id: recipient_membership.id,
        amount: 600
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
      html = response_io.to_s

      html.includes?("Alle sind ausgeglichen.").should be_true
      html.includes?("Noch keine Ausgaben.").should be_false
      html.includes?("Bezahlt!").should be_false
    end

    it "shows the settle action only to the debtor in debt rows" do
      debtor_user = User.create
      creditor_user = User.create
      group = Group.create(name: "Spec Group")
      debtor_membership = GroupMembership.create(group_id: group.id, user_id: debtor_user.id, name: "Anna")
      creditor_membership = GroupMembership.create(group_id: group.id, user_id: creditor_user.id, name: "Ben")

      Expense.create(
        group_id: group.id,
        group_membership_id: creditor_membership.id,
        weight_template_id: nil,
        description: "Dinner",
        amount: 1200
      )

      debtor_response_io = IO::Memory.new
      debtor_ctx = Crumble::Server::TestRequestContext.new(
        resource: GroupPage.uri_path(group_id: group.id),
        method: "GET",
        response_io: debtor_response_io
      )
      debtor_ctx.session.update!(user_id: debtor_user.id.value)
      GroupPage.handle(debtor_ctx).should be_true
      debtor_ctx.response.status_code.should eq(200)
      debtor_ctx.response.close
      debtor_response_io.rewind
      debtor_html = debtor_response_io.to_s
      debtor_html.includes?("Anna").should be_true
      debtor_html.includes?("Ben").should be_true
      debtor_html.includes?("6,00 €").should be_true
      debtor_html.includes?("Bezahlt!").should be_true
      debtor_html.includes?("Mit PayPal senden").should be_false
      debtor_html.includes?(Group::CreateReimbursementAction.uri_path(group.id.value)).should be_true
      debtor_html.includes?("value=\"#{creditor_membership.id.value}\"").should be_true

      creditor_response_io = IO::Memory.new
      creditor_ctx = Crumble::Server::TestRequestContext.new(
        resource: GroupPage.uri_path(group_id: group.id),
        method: "GET",
        response_io: creditor_response_io
      )
      creditor_ctx.session.update!(user_id: creditor_user.id.value)
      GroupPage.handle(creditor_ctx).should be_true
      creditor_ctx.response.status_code.should eq(200)
      creditor_ctx.response.close
      creditor_response_io.rewind
      creditor_html = creditor_response_io.to_s
      creditor_html.includes?("6,00 €").should be_true
      creditor_html.includes?("Bezahlt!").should be_false
    end

    it "shows a paypal link to debtors when the creditor has a paypal user name" do
      debtor_user = User.create
      creditor_user = User.create(paypal_username: "ben.paypal")
      group = Group.create(name: "Spec Group")
      debtor_membership = GroupMembership.create(group_id: group.id, user_id: debtor_user.id, name: "Anna")
      creditor_membership = GroupMembership.create(group_id: group.id, user_id: creditor_user.id, name: "Ben")

      Expense.create(
        group_id: group.id,
        group_membership_id: creditor_membership.id,
        weight_template_id: nil,
        description: "Dinner",
        amount: 1200
      )

      response_io = IO::Memory.new
      ctx = Crumble::Server::TestRequestContext.new(
        resource: GroupPage.uri_path(group_id: group.id),
        method: "GET",
        response_io: response_io
      )
      ctx.session.update!(user_id: debtor_user.id.value)
      GroupPage.handle(ctx).should be_true
      ctx.response.status_code.should eq(200)
      ctx.response.close
      response_io.rewind
      html = response_io.to_s

      html.includes?("Bezahlt!").should be_true
      html.includes?("Mit PayPal senden").should be_true
      html.includes?("href=\"https://paypal.me/ben.paypal/6.00EUR\"").should be_true
      html.includes?("target=\"_blank\"").should be_true
      Reimbursement.where(group_id: group.id).count.should eq(0)
    end
  end
end
