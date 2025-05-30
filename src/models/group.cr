require "./application_record"
require "./group_member"

class Group < ApplicationRecord
  column name : String
  column created_at : Time
  column updated_at : Time

  has_many_of GroupMember
end
