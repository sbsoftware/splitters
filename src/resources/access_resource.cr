require "./application_resource"

class AccessResource < ApplicationResource
  record AccessView, group : Group do
    css_class Container

    ToHtml.instance_template do
      div Container do
        p do
          "Du wurdest eingeladen, an der Gruppe "
          strong { group.name }
          " teilzunehmen!"
        end

        form action: AccessResource.uri_path(group.access_token.value), method: "POST" do
          button HomeView::IconButton do
            span HomeView::IconButtonCaption do
              "Teilnehmen"
            end
          end
        end
      end
    end

    style do
      rule Container do
        maxWidth 600.px
        margin "0px auto"
        display Flex
        flexDirection Column
        alignItems Center
      end
    end
  end

  def show
    unless id?
      redirect HomeResource.uri_path
      return
    end

    unless group = Group.where({"access_token" => id}).first?
      redirect HomeResource.uri_path
      return
    end

    render AccessView.new(group)
  end

  def update
    unless id?
      redirect HomeResource.uri_path
      return
    end

    unless group = Group.where({"access_token" => id}).first?
      redirect HomeResource.uri_path
      return
    end

    unless user = ctx.session.user
      user = User.create
      ctx.session.update!(user_id: user.id.value)
    end

    unless GroupMembership.where({"group_id" => group.id.value, "user_id" => user.id.value}).first?
      GroupMembership.create(group_id: group.id, user_id: user.id)
    end

    redirect GroupResource.uri_path(group.id)
  end

  def self.uri_path_matcher
    /^#{root_path}(\/|\/([a-zA-Z0-9]+))$/
  end

  def id?
    self.class.match(ctx.request.path).try { |m| m[2]? }
  end
end
