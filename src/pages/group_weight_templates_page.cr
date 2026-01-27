class GroupWeightTemplatesPage < ApplicationPage
  root_path "/groups"
  model group : Group
  nested_path "/weights"

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
        a href: GroupPage.uri_path(group_id: group.id) do
          Crumble::Material::Icon.new("arrow_back")
        end
      end
    end

    css_class CreateTemplateRow

    template do
      Crumble::Material::TopAppBar.new(
        leading_icon: BackLink.new(group),
        headline: "Gewichtungen",
        trailing_icons: [] of Nil,
        type: :center_aligned
      )

      group.weight_templates_list.renderer(ctx)

      div CreateTemplateRow do
        group.create_weight_template_action_template(ctx)
      end
    end

    style do
      rule CreateTemplateRow do
        padding 0.px, 16.px, 16.px, 16.px
        display :flex
        justify_content :center
        align_items :center

        rule form do
          display :flex
          gap 8.px
          width 100.percent
          max_width 360.px
        end
      end
    end
  end
end
