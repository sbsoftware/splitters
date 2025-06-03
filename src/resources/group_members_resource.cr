class GroupMembersResource < ApplicationResource
  def self.root_path
    "/groups"
  end

  def self.nested_path
    "/members"
  end

  layout ApplicationLayout do
    def top_app_bar
      nil
    end
  end

  def index
    group = Group.find(id)

    render Groups::MembersView.new(ctx, group)
  end
end
