module MinimumCashFlow
  # A single directed payment requirement: `debtor_id` must pay `creditor_id` `amount_cents`.
  record Debt, debtor_id : Int64, creditor_id : Int64, amount_cents : Int32

  # Computes an easy-to-follow set of pairwise payments that settles all expenses for the group.
  #
  # - `member_weights`: group membership id => weight (e.g. 10 means "1.0x")
  # - `expenses`: tuples of `{paid_by_member_id, amount_cents}`
  #
  # This method deliberately splits the *total* amount once to avoid rounding drift that would
  # occur if each expense was rounded individually.
  def self.pairwise_debts(member_weights : Hash(Int64, Int32), expenses : Array(Tuple(Int64, Int32))) : Array(Debt)
    return [] of Debt if member_weights.size < 2 || expenses.empty?

    member_ids = member_weights.keys.sort
    member_ids_set = member_ids.to_set

    # Ignore expenses from unknown payers (e.g. stale data) so we don't crash or skew results.
    valid_expenses = expenses.select { |paid_by_id, _| member_ids_set.includes?(paid_by_id) }
    return [] of Debt if valid_expenses.empty?

    # Total sum in cents (guard overflow because we return Int32 cent amounts in results).
    total_amount_cents_i64 = valid_expenses.sum(0_i64) { |(_, amount_cents)| amount_cents.to_i64 }
    raise "Total amount too large" if total_amount_cents_i64 > Int32::MAX
    total_amount_cents = total_amount_cents_i64.to_i32

    # "Owed" is computed from the total to keep the remainder distribution stable and minimal.
    owed_by_member = split_amount_by_weight(total_amount_cents, member_weights)

    # Sum up how much each member actually paid.
    paid_by_member = Hash(Int64, Int32).new(0)
    valid_expenses.each do |paid_by_id, amount_cents|
      paid_by_member[paid_by_id] += amount_cents
    end

    # Turn `paid - owed` into two lists:
    # - debtors: need to pay money (negative balance)
    # - creditors: should receive money (positive balance)
    debtors = [] of Tuple(Int64, Int32)
    creditors = [] of Tuple(Int64, Int32)

    member_ids.each do |member_id|
      paid = paid_by_member[member_id]? || 0
      owed = owed_by_member[member_id]
      balance = paid - owed

      if balance > 0
        creditors << {member_id, balance}
      elsif balance < 0
        debtors << {member_id, -balance}
      end
    end

    # Greedily transfer from debtors to creditors.
    # This produces a small, deterministic set of payments that settles everyone to zero.
    result = [] of Debt
    debtor_idx = 0
    creditor_idx = 0

    while debtor_idx < debtors.size && creditor_idx < creditors.size
      debtor_id, debtor_amount = debtors[debtor_idx]
      creditor_id, creditor_amount = creditors[creditor_idx]

      transfer = debtor_amount < creditor_amount ? debtor_amount : creditor_amount
      result << Debt.new(debtor_id: debtor_id, creditor_id: creditor_id, amount_cents: transfer)

      debtor_amount -= transfer
      creditor_amount -= transfer

      if debtor_amount == 0
        debtor_idx += 1
      else
        debtors[debtor_idx] = {debtor_id, debtor_amount}
      end

      if creditor_amount == 0
        creditor_idx += 1
      else
        creditors[creditor_idx] = {creditor_id, creditor_amount}
      end
    end

    result
  end

  # Splits `amount_cents` among members proportional to their weights.
  #
  # The split is:
  # - deterministic (tie-break by member id)
  # - exact in cents (sums back to `amount_cents`)
  #
  # Remainder cents are distributed to members with the largest fractional remainders first.
  def self.split_amount_by_weight(amount_cents : Int32, member_weights : Hash(Int64, Int32)) : Hash(Int64, Int32)
    total_weight = member_weights.values.sum(&.to_i64)
    raise "Total weight must be positive" if total_weight <= 0

    shares = Hash(Int64, Int32).new
    remainder_parts = [] of Tuple(Int64, Int64)

    # Start with floor shares and track each member's remainder for fair distribution.
    sum_floor = 0_i64
    member_weights.each do |member_id, weight|
      numerator = amount_cents.to_i64 * weight
      floor_share = (numerator // total_weight).to_i32
      remainder_part = numerator % total_weight

      shares[member_id] = floor_share
      sum_floor += floor_share
      remainder_parts << {remainder_part, member_id}
    end

    # Distribute remaining cents.
    remaining = amount_cents.to_i64 - sum_floor
    if remaining <= 0
      return shares
    end

    # Highest remainder first; tie-break by id for stable results.
    remainder_parts.sort! do |a, b|
      remainder_cmp = b[0] <=> a[0]
      next remainder_cmp unless remainder_cmp == 0
      a[1] <=> b[1]
    end

    # Walk the ordered remainder list, adding +1 cent until we match the target sum.
    idx = 0
    while remaining > 0
      member_id = remainder_parts[idx][1]
      shares[member_id] += 1
      remaining -= 1
      idx += 1
      idx = 0 if idx >= remainder_parts.size
    end

    shares
  end
end
