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
    css_class Name
    css_class Weight

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
            span Name do
              if name = group_membership.name
                name
              else
                i do
                  "Anonym"
                end
              end
            end
            span Weight do
              group_membership.set_weight_form.renderer(ctx)
            end
          end
        end
      end
    end

    style do
      rule Member do
        display :flex
        gap 8.px
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
