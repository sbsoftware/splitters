class HomeView
  css_class AddGroupButton
  css_class IconButton
  css_class IconButtonCaption

  ToHtml.class_template do
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
  end

  style do
    rule AddGroupButton do
      display Flex
      justifyContent Center
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
  end
end
