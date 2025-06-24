class Expense < ApplicationRecord
  column group_id : Int64
  column group_membership_id : Int64
  column description : String
  column amount : Int32
  column created_at : Time
  column updated_at : Time

  def group_membership
    GroupMembership.find(group_membership_id)
  end
end
