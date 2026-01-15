class Reimbursement < ApplicationRecord
  column group_id : Int64
  column payer_membership_id : Int64
  column recipient_membership_id : Int64
  column amount : Int32
  column created_at : Time
  column updated_at : Time

  def payer_membership
    GroupMembership.find(payer_membership_id)
  end

  def recipient_membership
    GroupMembership.find(recipient_membership_id)
  end
end
