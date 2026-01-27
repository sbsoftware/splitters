require "../spec_helper"

describe MinimumCashFlow do
  describe ".split_amount_by_weight" do
    it "splits equally and assigns the remainder deterministically by member id" do
      member_weights = {
        1_i64 => 10,
        2_i64 => 10,
        3_i64 => 10,
      }

      # 14.50€ => 1450 cents => 483/483/484 (one extra cent)
      MinimumCashFlow.split_amount_by_weight(1450, member_weights).should eq({
        1_i64 => 484,
        2_i64 => 483,
        3_i64 => 483,
      })
    end

    it "returns zero shares for zero amount" do
      member_weights = {
        10_i64 => 10,
        20_i64 => 10,
      }

      MinimumCashFlow.split_amount_by_weight(0, member_weights).should eq({
        10_i64 => 0,
        20_i64 => 0,
      })
    end

    it "raises when total weight is not positive" do
      member_weights = {
        1_i64 => 0,
        2_i64 => 0,
      }

      expect_raises(Exception, "Total weight must be positive") do
        MinimumCashFlow.split_amount_by_weight(100, member_weights)
      end
    end
  end

  describe ".balances_from_weighted_expenses" do
    it "computes a single debt for a single expense" do
      member_weights = {
        1_i64 => 10,
        2_i64 => 10,
      }
      expenses = [
        MinimumCashFlow::WeightedExpense.new(
          paid_by_member_id: 2_i64,
          amount_cents: 700,
          member_weights: member_weights
        ),
      ]

      balances = MinimumCashFlow.balances_from_weighted_expenses(expenses)
      MinimumCashFlow.pairwise_debts_from_balances(balances).should eq([
        MinimumCashFlow::Debt.new(debtor_id: 1_i64, creditor_id: 2_i64, amount_cents: 350),
      ])
    end

    it "nets mutual debts to the remaining direction" do
      member_weights = {
        1_i64 => 10,
        2_i64 => 10,
      }
      expenses = [
        MinimumCashFlow::WeightedExpense.new(
          paid_by_member_id: 1_i64,
          amount_cents: 1000,
          member_weights: member_weights
        ),
        MinimumCashFlow::WeightedExpense.new(
          paid_by_member_id: 2_i64,
          amount_cents: 700,
          member_weights: member_weights
        ),
      ]

      balances = MinimumCashFlow.balances_from_weighted_expenses(expenses)
      MinimumCashFlow.pairwise_debts_from_balances(balances).should eq([
        MinimumCashFlow::Debt.new(debtor_id: 2_i64, creditor_id: 1_i64, amount_cents: 150),
      ])
    end

    it "splits by weight across multiple members" do
      member_weights = {
        1_i64 => 10,
        2_i64 => 10,
        3_i64 => 20,
      }
      expenses = [
        MinimumCashFlow::WeightedExpense.new(
          paid_by_member_id: 1_i64,
          amount_cents: 100,
          member_weights: member_weights
        ),
      ]

      balances = MinimumCashFlow.balances_from_weighted_expenses(expenses)
      MinimumCashFlow.pairwise_debts_from_balances(balances).should eq([
        MinimumCashFlow::Debt.new(debtor_id: 2_i64, creditor_id: 1_i64, amount_cents: 25),
        MinimumCashFlow::Debt.new(debtor_id: 3_i64, creditor_id: 1_i64, amount_cents: 50),
      ])
    end

    it "ignores expenses paid by unknown members" do
      member_weights = {
        1_i64 => 10,
        2_i64 => 10,
      }
      expenses = [
        MinimumCashFlow::WeightedExpense.new(
          paid_by_member_id: 999_i64,
          amount_cents: 500,
          member_weights: member_weights
        ),
        MinimumCashFlow::WeightedExpense.new(
          paid_by_member_id: 2_i64,
          amount_cents: 700,
          member_weights: member_weights
        ),
      ]

      balances = MinimumCashFlow.balances_from_weighted_expenses(expenses)
      MinimumCashFlow.pairwise_debts_from_balances(balances).should eq([
        MinimumCashFlow::Debt.new(debtor_id: 1_i64, creditor_id: 2_i64, amount_cents: 350),
      ])
    end

    it "returns an empty list if all expenses are from unknown members" do
      member_weights = {
        1_i64 => 10,
        2_i64 => 10,
      }
      expenses = [
        MinimumCashFlow::WeightedExpense.new(
          paid_by_member_id: 999_i64,
          amount_cents: 500,
          member_weights: member_weights
        ),
      ]

      balances = MinimumCashFlow.balances_from_weighted_expenses(expenses)
      balances.should eq({
        1_i64 => 0,
        2_i64 => 0,
      })
      MinimumCashFlow.pairwise_debts_from_balances(balances).should eq([] of MinimumCashFlow::Debt)
    end

    it "returns an empty list with fewer than two members" do
      member_weights = {1_i64 => 10}
      expenses = [
        MinimumCashFlow::WeightedExpense.new(
          paid_by_member_id: 1_i64,
          amount_cents: 500,
          member_weights: member_weights
        ),
      ]

      balances = MinimumCashFlow.balances_from_weighted_expenses(expenses)
      balances.should eq({} of Int64 => Int32)
      MinimumCashFlow.pairwise_debts_from_balances(balances).should eq([] of MinimumCashFlow::Debt)
    end

    it "raises when member weights are invalid" do
      member_weights = {
        1_i64 => 0,
        2_i64 => 0,
      }
      expenses = [
        MinimumCashFlow::WeightedExpense.new(
          paid_by_member_id: 1_i64,
          amount_cents: 100,
          member_weights: member_weights
        ),
      ]

      expect_raises(Exception, "Total weight must be positive") do
        MinimumCashFlow.balances_from_weighted_expenses(expenses)
      end
    end
  end
end
