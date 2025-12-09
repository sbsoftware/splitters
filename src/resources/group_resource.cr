require "base58"

class GroupResource < ApplicationResource
  layout ApplicationLayout do
    def top_app_bar
      nil
    end
  end

  def create
    unless user = ctx.session.user
      user = User.create
      ctx.session.update!(user_id: user.id.value)
    end

    group = Group.create(name: "Neue Gruppe", access_token: Base58.encode(Random::Secure.random_bytes(9)))
    GroupMembership.create(group_id: group.id, user_id: user.id)

    redirect self.class.uri_path(group.id)
  end

  def show
    unless user = ctx.session.user
      redirect HomeResource.uri_path
      return
    end

    group = Group.find(id)
    if group_membership = group.group_memberships.find { |gm| gm.user_id == user.id }
      render GroupView.new(ctx: ctx, group_membership: group_membership)
    else
      redirect HomeResource.uri_path
    end
  end
end
