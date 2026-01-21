class GroupMembersPage < ApplicationPage
  root_path "/groups"
  model group : Group
  nested_path "/members"

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

    template do
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
