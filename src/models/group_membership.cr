require "./application_record"
require "./group"

class GroupMembership < ApplicationRecord
  column group_id : Int64
  column user_id : Int64

  def group
    Group.find(group_id)
  end
end
