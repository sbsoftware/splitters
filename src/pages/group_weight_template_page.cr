class GroupWeightTemplatePage < ApplicationPage
  root_path "/groups"
  model group : Group
  nested_path "/weights"
  model weight_template : WeightTemplate

  before do
    unless user = ctx.session.user
      redirect HomePage.uri_path
      return 303
    end

    current_group = group.not_nil!
    unless current_group.group_memberships.any? { |gm| gm.user_id == user.id }
      redirect HomePage.uri_path
      return 303
    end

    current_template = weight_template.not_nil!
    return 404 unless current_template.group_id == current_group.id

    true
  end

  layout ApplicationLayout do
    def top_app_bar
      nil
    end
  end

  view do
    class BackLink
      getter group : Group

      def initialize(@group); end

      ToHtml.instance_template do
        a href: GroupWeightTemplatesPage.uri_path(group_id: group.id) do
          Crumble::Material::Icon.new("arrow_back")
        end
      end
    end

    css_class MembersList
    css_class MemberRow
    css_class Name
    css_class Weight

    template do
      Crumble::Material::TopAppBar.new(
        leading_icon: BackLink.new(group),
        headline: weight_template.name,
        trailing_icons: [] of Nil,
        type: :center_aligned
      )

      template_memberships = weight_template.weight_template_memberships.to_a
      template_by_member = template_memberships.to_h do |template_membership|
        {template_membership.group_membership_id.value, template_membership}
      end

      div MembersList do
        group.group_memberships.each do |membership|
          template_membership = template_by_member[membership.id.value]?

          Crumble::Material::ListItem.to_html do
            div MemberRow do
              Crumble::Material::Icon.new("account_circle")
              span Name do
                membership.display_name
              end
              span Weight do
                if template_membership
                  template_membership.set_weight_form.renderer(ctx)
                else
                  "-"
                end
              end
            end
          end
        end
      end
    end

    style do
      rule MembersList do
        display :block
        padding 16.px
        box_sizing :border_box
      end

      rule MemberRow do
        display :flex
        gap 8.px
        align_items :center
      end

      rule Name do
        flex_grow 2
      end

      rule Weight do
        rule input do
          width 55.px
          vertical_align :middle
        end
      end
    end
  end
end
