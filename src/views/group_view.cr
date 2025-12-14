class GroupView
  include Crumble::ContextView

  getter group_membership : GroupMembership

  def initialize(@ctx, @group_membership); end

  delegate :group, to: group_membership

  class BackLink
    ToHtml.class_template do
      a HomeResource do
        Crumble::Material::Icon.new("arrow_back")
      end
    end
  end

  record ShareIcon, group : Group do
    ToHtml.instance_template do
      group.share_element.to_html do
        Crumble::Material::Icon.new("share")
      end
    end
  end

  record MembersLink, group : Group do
    ToHtml.instance_template do
      a href: GroupMembersResource.uri_path(group.id) do
        Crumble::Material::Icon.new("group")
      end
    end
  end

  def top_app_bar
    Crumble::Material::TopAppBar.new(
      leading_icon: BackLink,
      headline: group.name,
      trailing_icons: [ShareIcon.new(group), MembersLink.new(group)]
    )
  end

  ToHtml.instance_template do
    top_app_bar
    group_membership.set_name_form.renderer(ctx)
  end
end
