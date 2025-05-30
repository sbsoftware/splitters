class GroupView
  getter group_member : GroupMembership

  def initialize(@group_member); end

  delegate :group, to: group_member

  class BackLink
    ToHtml.class_template do
      a HomeResource do
        Crumble::Material::Icon.new("arrow_back")
      end
    end
  end

  def top_app_bar
    Crumble::Material::TopAppBar.new(
      leading_icon: BackLink,
      headline: group.name,
      trailing_icons: [] of Nil
    )
  end

  ToHtml.instance_template do
    top_app_bar
  end
end
