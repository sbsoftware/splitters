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

    group = Group.create(name: "Neue Gruppe")
    GroupMember.create(group_id: group.id, user_id: user.id)

    redirect self.class.uri_path(group.id)
  end

  def show
    unless user = ctx.session.user
      redirect HomeResource.uri_path
      return
    end

    group = Group.find(id)
    if group_member = group.group_members.find { |gm| gm.user_id == user.id }
      render GroupView.new(group_member)
    else
      redirect HomeResource.uri_path
    end
  end
end
