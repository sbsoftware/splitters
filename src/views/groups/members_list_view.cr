module Groups
  class MembersListView
    include Crumble::ContextView

    getter group : Group

    def initialize(@ctx, @group); end

    css_class MembersList
    css_class MemberRow
    css_class EditableMemberRow
    css_class Name
    css_class NameButton
    css_class YouBadge
    css_class Weight
    css_class HideNameForm

    stimulus_controller NameEditorController do
      action :toggle do
        form = this.element.querySelector(GroupMembership::UpdateNameAction::NameForm.to_css_selector.to_s.to_js_ref)
        form.classList.toggle(GroupMembership::UpdateNameAction::ForceVisible)
        visible = form.classList.contains(GroupMembership::UpdateNameAction::ForceVisible)

        input = _literal_js("undefined")
        if visible
          input = this.element.querySelector(GroupMembership::UpdateNameAction::NameInput.to_css_selector.to_s.to_js_ref)
          input.focus._call
          input.select._call
        end
      end
    end

    ToHtml.instance_template do
      div MembersList do
        group.group_memberships.each do |group_membership|
          action_template = group_membership.update_name_action_template(ctx)
          action = action_template.action
          controller = Groups::MembersListView::NameEditorController
          Crumble::Material::ListItem.to_html do
            div controller, HideNameForm do
              if action.editable?
                div MemberRow, EditableMemberRow do
                  Crumble::Material::Icon.new("account_circle")
                  span Name do
                    button NameButton, controller.toggle_action("click"), type: :button do
                      group_membership.name_display.renderer(ctx)
                    end
                    span YouBadge do
                      "Du"
                    end
                  end
                  span Weight do
                    group_membership.set_weight_form.renderer(ctx)
                  end
                end
                action_template.to_html
              else
                div MemberRow do
                  Crumble::Material::Icon.new("account_circle")
                  span Name do
                    group_membership.name_display.renderer(ctx)
                  end
                  span Weight do
                    group_membership.set_weight_form.renderer(ctx)
                  end
                end
              end
            end
          end
        end
      end
    end

    style do
      rule MembersList do
        display :block
      end

      rule MemberRow do
        display :flex
        gap 8.px
      end

      rule EditableMemberRow do
        background_color "#f5f7ff"
        border_radius 8.px
        margin -8.px, -16.px
        padding 8.px, 16.px
      end

      rule Name do
        flex_grow 2
      end

      rule NameButton do
        background_color :transparent
        border :none
        padding 0.px
        color :inherit
        font_size :inherit
        font_weight :inherit
        cursor :pointer
      end

      rule YouBadge do
        display :inline_block
        margin_left 8.px
        padding 2.px, 6.px
        border_radius 999.px
        font_size 12.px
        line_height 1.2
        vertical_align :middle
        position :relative
        top -2.px
        background_color "#d7e2ff"
        color "#2a3a74"
      end

      rule Weight do
        rule input do
          width 55.px
          vertical_align :middle
        end
      end

      rule HideNameForm do
        rule GroupMembership::UpdateNameAction::NameForm do
          display :none
        end
      end
    end
  end
end
