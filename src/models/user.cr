require "./application_record"
require "./group_membership"

class User < ApplicationRecord
  column name : String?
  column created_at : Time
  column updated_at : Time

  has_many_of GroupMembership

  def preferred_name : String?
    if current_name = name
      value = current_name.value
      return value unless value.empty?
    end

    memberships_with_names = group_memberships.to_a.select(&.name)
    membership = memberships_with_names.max_by?(&.id.value)
    membership.try(&.name).try(&.value)
  end
end
