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

  css_class Container

  ToHtml.instance_template do
    top_app_bar
    div Container do
      group_membership.set_name_form.renderer(ctx)
      group.expenses_summary_view.renderer(ctx)
      group.create_expense_action_template(ctx)
      group.expenses_view.renderer(ctx)
    end
  end

  style do
    rule Container do
      padding 16.px
      box_sizing :border_box
      border_top 1.px, :solid, :silver
      border_bottom 1.px, :solid, :silver
    end
  end
end
