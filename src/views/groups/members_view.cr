module Groups
  class MembersView
    include Crumble::ContextView

    getter group : Group

    def initialize(@ctx, @group); end

    record BackLink, group : Group do
      ToHtml.instance_template do
        a href: GroupResource.uri_path(group.id) do
          Crumble::Material::Icon.new("arrow_back")
        end
      end
    end

    css_class Member

    ToHtml.instance_template do
      Crumble::Material::TopAppBar.new(
        leading_icon: BackLink.new(group),
        headline: "Teilnehmer",
        trailing_icons: [] of Nil,
        type: :center_aligned
      )
      group.group_memberships.each do |group_membership|
        Crumble::Material::ListItem.to_html do
          div Member do
            Crumble::Material::Icon.new("account_circle")
            if name = group_membership.name
              name
            else
              i do
                "Anonym"
              end
            end
          end
        end
      end
    end

    style do
      rule Member do
        display Flex
        prop("gap", 8.px)
      end
    end
  end
end
