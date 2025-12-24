class GroupMembersPage < ApplicationPage
  def self.root_path
    "/groups"
  end

  def self.nested_path
    "/members"
  end

  def self.uri_path_matcher
    /^\/groups(\/(\d+))\/members$/
  end

  layout ApplicationLayout do
    def top_app_bar
      nil
    end
  end

  def call
    group = Group.find(id)
    render Groups::MembersView.new(ctx, group)
  end
end
