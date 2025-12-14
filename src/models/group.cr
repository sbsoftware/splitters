require "./application_record"
require "./group_membership"
require "../resources/application_resource"

class Group < ApplicationRecord
  column name : String
  column created_at : Time
  column updated_at : Time

  has_many_of GroupMembership

  model_template :card do
    a href: GroupResource.uri_path(id) do
      Crumble::Material::Card.new.to_html do
        Crumble::Material::Card::Title.new(name)
        Crumble::Material::Card::SecondaryText.new.to_html do
          Crumble::Material::Icon.new("account_circle", "#{group_memberships.count} Mitglied(er)")
        end
      end
    end
  end

  accessible GroupMembership, GroupResource, card do
    access_model_attributes user_id: ctx.session.ensure_user.id.value

    access_view do
      css_class Container

      ToHtml.instance_template do
        div Container do
          p do
            "Du wurdest eingeladen, an der Gruppe "
            strong { model.name }
            " teilzunehmen!"
          end

          model.accept_access_action_template(ctx)
        end
      end

      style do
        rule Container do
          max_width 600.px
          margin 0.px, :auto
          display :flex
          flex_direction :column
          align_items :center
          gap 12.px
        end
      end
    end

    accept_access_view do
      ToHtml.instance_template do
        button HomeView::IconButton do
          span HomeView::IconButtonCaption do
            "Teilnehmen"
          end
        end
      end
    end
  end
end
