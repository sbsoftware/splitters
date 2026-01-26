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

    css_class TemplatesGrid
    css_class TemplateCardLink

    template do
      Crumble::Material::TopAppBar.new(
        leading_icon: BackLink.new(group),
        headline: "Gewichtungen",
        trailing_icons: [] of Nil,
        type: :center_aligned
      )

      div TemplatesGrid do
        group.weight_templates.order_by_id!.each do |weight_template|
          a TemplateCardLink, href: GroupWeightTemplatePage.uri_path(group.id, weight_template.id) do
            Crumble::Material::Card.new.to_html do
              Crumble::Material::Card::Title.new(weight_template.name)
              Crumble::Material::Card::SecondaryText.new.to_html do
                "#{weight_template.weight_template_memberships.count} Mitglied(er)"
              end
            end
          end
        end
      end
    end

    style do
      rule TemplatesGrid do
        padding 16.px
        display :grid
        property(
          "grid-template-columns",
          "repeat(auto-fill, minmax(min(320px, 100%), 1fr))"
        )
        gap 16.px
        box_sizing :border_box
      end

      rule TemplateCardLink do
        display :block
        color :inherit
        text_decoration :none
      end
    end
  end
end
