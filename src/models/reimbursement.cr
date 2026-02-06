class Reimbursement < ApplicationRecord
  column group_id : Int64
  column payer_membership_id : Int64
  column recipient_membership_id : Int64
  column amount : Int32
  column created_at : Time
  column updated_at : Time

  css_class DeleteCardAction
  css_class DeleteCardForm
  css_class DeleteCardButton
  css_class DeleteError

  def group
    Group.find(group_id)
  end

  def payer_membership
    GroupMembership.find(payer_membership_id)
  end

  def recipient_membership
    GroupMembership.find(recipient_membership_id)
  end

  def editable_by?(user_id : Int64?) : Bool
    return false unless current_user_id = user_id

    payer_membership.user_id.value == current_user_id
  end

  model_action :delete_from_card, {group.expenses_view, group.expenses_summary_view} do
    @delete_error_message : String? = nil

    policy do
      can_view do
        model.editable_by?(ctx.session.user_id)
      end

      can_submit do
        model.editable_by?(ctx.session.user_id)
      end
    end

    controller do
      begin
        model.destroy
      rescue Exception
        @delete_error_message = "Löschen fehlgeschlagen. Bitte erneut versuchen."
        ctx.response.status = :unprocessable_entity
      end
    end

    def delete_error_message : String?
      @delete_error_message
    end

    view do
      template do
        div DeleteCardAction do
          form DeleteCardForm, action: action.uri_path, method: "POST", onsubmit: "return window.confirm('Rückerstattung wirklich löschen?');" do
            button DeleteCardButton, type: :submit, title: "Rückerstattung löschen" do
              "x"
            end
          end
          if error_message = action.delete_error_message
            div DeleteError do
              error_message
            end
          end
        end
      end
    end
  end

  style do
    rule DeleteCardAction do
      position :absolute
      top 8.px
      right 8.px
      z_index 2
      display :flex
      flex_direction :column
      align_items :flex_end
    end

    rule DeleteCardForm do
      margin 0.px
    end

    rule DeleteCardButton do
      width 24.px
      height 24.px
      border 1.px, :solid, :black
      border_radius 999.px
      background_color :white
      cursor :pointer
      line_height 1
      padding 0.px
      font_size 0.9.rem
    end

    rule DeleteError do
      margin_top 6.px
      font_size 0.75.rem
      color "#a40000"
      text_align :right
    end
  end
end
