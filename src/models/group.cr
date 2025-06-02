require "./application_record"
require "./group_membership"

class Group < ApplicationRecord
  column name : String
  column created_at : Time
  column updated_at : Time
  column access_token : String

  has_many_of GroupMembership
end
