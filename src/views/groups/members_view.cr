module Groups
  class MembersView
    include Crumble::ContextView

    getter group : Group

    def initialize(@ctx, @group); end

    record BackLink, group : Group do
      ToHtml.instance_template do
        a href: GroupPage.uri_path(group.id) do
          Crumble::Material::Icon.new("arrow_back")
        end
      end
    end

    ToHtml.instance_template do
      Crumble::Material::TopAppBar.new(
        leading_icon: BackLink.new(group),
        headline: "Teilnehmer",
        trailing_icons: [] of Nil,
        type: :center_aligned
      )
      group.members_list_view.renderer(ctx)
    end
  end
end
