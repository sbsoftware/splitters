class GroupView
  getter group_membership : GroupMembership

  def initialize(@group_membership); end

  delegate :group, to: group_membership

  class BackLink
    ToHtml.class_template do
      a HomeResource do
        Crumble::Material::Icon.new("arrow_back")
      end
    end
  end

  record ShareLink, group : Group do
    stimulus_controller ShareController do
      values url: String

      action :share do |event|
        event.preventDefault._call

        if navigator.share
          navigator.share({text: this.urlValue})
        else
          window.alert("Teilen auf diesem Gerät leider nicht möglich!")
        end
      end
    end

    ToHtml.instance_template do
      div ShareController, ShareController.share_action("click"), ShareController.url_value("https://splitters.money#{AccessResource.uri_path(group.access_token.value)}")do
        Crumble::Material::Icon.new("share")
      end
    end
  end

  record MembersLink, group : Group do
    ToHtml.instance_template do
      a href: GroupMembersResource.uri_path(group.id) do
        Crumble::Material::Icon.new("group")
      end
    end
  end

  def top_app_bar
    Crumble::Material::TopAppBar.new(
      leading_icon: BackLink,
      headline: group.name,
      trailing_icons: [ShareLink.new(group), MembersLink.new(group)]
    )
  end

  ToHtml.instance_template do
    top_app_bar
    group_membership.set_name_form
  end
end
