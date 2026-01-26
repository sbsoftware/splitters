class GroupPage < ApplicationPage
  root_path "/groups"

  model group : Group

  before do
    unless user = ctx.session.user
      redirect HomePage.uri_path
      return 303
    end

    current_group = group.not_nil!
    membership = current_group.group_memberships.find { |gm| gm.user_id == user.id }
    unless membership
      redirect HomePage.uri_path
      return 303
    end

    @group_membership = membership
    true
  end

  layout ApplicationLayout do
    def top_app_bar
      nil
    end
  end

  getter group_membership : GroupMembership?

  view do
    def group_membership : GroupMembership
      ctx.handler.as(GroupPage).group_membership.not_nil!
    end

    delegate :group, to: group_membership

    class BackLink
      ToHtml.class_template do
        a HomePage do
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
        a href: GroupMembersPage.uri_path(group_id: group.id) do
          Crumble::Material::Icon.new("group")
        end
      end
    end

    record WeightTemplatesLink, group : Group do
      ToHtml.instance_template do
        a href: GroupWeightTemplatesPage.uri_path(group_id: group.id) do
          Crumble::Material::Icon.new("balance")
        end
      end
    end

    def top_app_bar
      Crumble::Material::TopAppBar.new(
        leading_icon: BackLink,
        headline: group.top_app_bar_headline.renderer(ctx),
        trailing_icons: [ShareIcon.new(group), WeightTemplatesLink.new(group), MembersLink.new(group)]
      )
    end

    css_class Container

    template do
      div group.update_name_controller do
        top_app_bar
        div Container do
          group.update_name_action_template(ctx)
          group_membership.name_prompt_box.renderer(ctx)
          group.expenses_summary_view.renderer(ctx)
          group.create_expense_action_template(ctx)
          group.create_reimbursement_action_template(ctx)
          group.expenses_view.renderer(ctx)
        end
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
end
