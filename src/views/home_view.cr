class HomeView
  include Crumble::ContextView

  css_class HomeView
  css_class AddGroupButton
  css_class IconButton
  css_class IconButtonCaption
  css_class Groups

  def groups
    return ([] of Group) unless user = ctx.session.user

    user.group_memberships.map(&.group)
  end

  ToHtml.instance_template do
    div HomeView do
      div AddGroupButton do
        form action: GroupResource.uri_path, method: "POST" do
          button IconButton do
            Crumble::Material::Icon.new("add_circle")
            span IconButtonCaption do
              "Neue Gruppe"
            end
          end
        end
      end
      div Groups do
        groups.each do |group|
          a href: GroupResource.uri_path(group.id) do
            Crumble::Material::Card.new.to_html do
              Crumble::Material::Card::Title.new(group.name)
              Crumble::Material::Card::SecondaryText.new.to_html do
                Crumble::Material::Icon.new("account_circle", "#{group.group_memberships.count} Mitglied(er)")
              end
            end
          end
        end
      end
    end
  end

  style do
    rule HomeView do
      padding 16.px
    end

    rule AddGroupButton do
      display Flex
      justifyContent Center
      marginBottom 16.px
    end

    rule IconButton do
      display Flex
      alignItems Center
      prop("gap", 5.px)
      backgroundColor White
      padding 8.px
      border 1.px, Solid, Black
      prop("border-radius", 8.px)
    end

    rule IconButtonCaption do
      fontSize 120.percent
    end

    rule Groups do
      display Flex
      flexWrap Wrap
      prop("gap", 16.px)
    end
  end
end
