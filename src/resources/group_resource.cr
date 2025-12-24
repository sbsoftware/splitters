require "base58"

class GroupResource < ApplicationResource
  def create
    unless user = ctx.session.user
      user = User.create
      ctx.session.update!(user_id: user.id.value)
    end

    group = Group.create(name: "Neue Gruppe", access_token: Base58.encode(Random::Secure.random_bytes(9)))
    GroupMembership.create(group_id: group.id, user_id: user.id, name: user.preferred_name)

    redirect self.class.uri_path(group.id)
  end
end
