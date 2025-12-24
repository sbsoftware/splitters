class GroupPage < ApplicationPage
  def self.root_path
    "/groups"
  end

  def self.uri_path_matcher
    /^\/groups(\/(\d+))$/
  end

  layout ApplicationLayout do
    def top_app_bar
      nil
    end
  end

  def call
    unless user = ctx.session.user
      redirect HomePage.uri_path
      return
    end

    group = Group.find(id)
    if group_membership = group.group_memberships.find { |gm| gm.user_id == user.id }
      render GroupView.new(ctx: ctx, group_membership: group_membership)
    else
      redirect HomePage.uri_path
    end
  end
end
