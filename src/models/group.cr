require "./application_record"
require "./group_membership"
require "../resources/application_resource"

class Group < ApplicationRecord
  column name : String
  column created_at : Time
  column updated_at : Time

  has_many_of GroupMembership
  has_many_of Expense

  css_class TopAppBarHeadlineWrapper
  css_class TopAppBarHeadlineButton

  private def format_euros(amount_cents : Int32) : String
    (amount_cents.to_f / 100).format(",", ".", decimal_places: 2)
  end

  def expense_debt_statements : Array(String)
    memberships = group_memberships.to_a
    return [] of String if memberships.size < 2

    member_weights = memberships.to_h { |gm| {gm.id.value, gm.weight.value} }
    expenses_input = expenses.map { |e| {e.group_membership_id.value, e.amount.value} }

    membership_by_id = memberships.to_h { |gm| {gm.id.value, gm} }

    MinimumCashFlow
      .pairwise_debts(member_weights: member_weights, expenses: expenses_input)
      .sort_by do |debt|
        debtor = membership_by_id[debt.debtor_id]
        creditor = membership_by_id[debt.creditor_id]
        {debtor.display_name, creditor.display_name}
      end
      .map do |debt|
        debtor = membership_by_id[debt.debtor_id]
        creditor = membership_by_id[debt.creditor_id]
        "#{debtor.display_name} schuldet #{creditor.display_name} #{format_euros(debt.amount_cents)}€"
      end
  end

  model_template :top_app_bar_headline, [TopAppBarHeadlineWrapper] do
    button TopAppBarHeadlineButton, update_name_controller.toggle_action("click"), type: :button do
      name
    end
  end

  def update_name_controller
    UpdateNameAction::NameEditorController
  end

  model_template :card do
    a href: GroupPage.uri_path(id) do
      Crumble::Material::Card.new.to_html do
        Crumble::Material::Card::Title.new(name)
        Crumble::Material::Card::SecondaryText.new.to_html do
          Crumble::Material::Icon.new("account_circle", "#{group_memberships.count} Mitglied(er)")
        end
      end
    end
  end

  model_action :update_name, top_app_bar_headline do
    css_class FormContainer
    css_class FieldRow
    css_class NameInput
    css_class ButtonRow
    css_class ErrorMessage

    stimulus_controller NameEditorController do
      targets :form, :input

      action :toggle do
        this.formTarget.hidden = !this.formTarget.hidden

        unless this.formTarget.hidden
          this.inputTarget.focus._call
          this.inputTarget.select._call
        end
      end
    end

    form do
      field name : String

      def valid?
        super

        errors = @errors.not_nil!
        if (value = name) && value.strip.empty?
          errors << "name"
        end

        errors.none?
      end

      def normalized_name : String?
        name.try(&.strip)
      end

      ToHtml.instance_template do
        div FieldRow do
          input NameInput, NameEditorController.input_target, type: :text, name: "name", value: name.to_s, required: true
        end
      end
    end

    @submitted_form : Form? = nil

    def form
      @submitted_form || Form.new(name: model.name.value)
    end

    def show_form? : Bool
      if errors = form.errors
        errors.any?
      else
        false
      end
    end

    before do
      return 403 unless user_id = ctx.session.user_id

      return 403 unless model.group_memberships.any? { |gm| gm.user_id == user_id }

      true
    end

    controller do
      unless body = ctx.request.body
        ctx.response.status = :bad_request
        return
      end

      @submitted_form = Form.from_www_form(body.gets_to_end)
      form = @submitted_form.not_nil!

      unless form.valid?
        ctx.response.status = :unprocessable_entity
        return
      end

      new_name = form.normalized_name
      return unless new_name

      model.update(name: new_name)
      model.card.refresh!
    end

    view do
      template do
        div NameEditorController.form_target, hidden: !action.show_form? do
          div FormContainer do
            action_form.to_html do
              if errors = action.form.errors
                if errors.includes?("name")
                  div ErrorMessage do
                    "Bitte gib einen Gruppennamen ein."
                  end
                end
              end

              div ButtonRow do
                button do
                  "Speichern"
                end
              end
            end
          end
        end
      end

      style do
        rule FormContainer do
          padding 16.px
          border 1.px, :solid, :silver
          margin_bottom 16.px
          max_width 800.px
          margin_left :auto
          margin_right :auto
          box_sizing :border_box
        end

        rule FieldRow do
          display :flex
        end

        rule NameInput do
          width 100.percent
        end

        rule ButtonRow do
          margin_top 12.px
          display :flex
          justify_content :flex_end
        end

        rule ErrorMessage do
          margin_bottom 10.px
        end
      end
    end
  end

  accessible GroupMembership, GroupPage, card do
    access_model_attributes user_id: ctx.session.ensure_user.id.value, name: ctx.session.ensure_user.preferred_name

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
          max_width 800.px
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

  model_action :create_expense, expenses_view do
    DESCRIPTION_FIELD = "description"
    AMOUNT_FIELD      = "amount"

    controller do
      unless body = ctx.request.body
        ctx.response.status = :bad_request
        return
      end

      description = nil
      amount = nil
      HTTP::Params.parse(body.gets_to_end) do |key, value|
        case key
        when DESCRIPTION_FIELD
          description = value
        when AMOUNT_FIELD
          amount = (value.to_f * 100).floor.to_i
        end
      end

      group_membership = model.group_memberships.find do |group_membership|
        group_membership.user_id == ctx.session.user_id
      end

      unless description && amount && group_membership
        ctx.response.status = :unprocessable_entity
        return
      end

      Expense.create(description: description, amount: amount, group_id: model.id, group_membership_id: group_membership.id)

      model.expenses_summary_view.refresh!
      ctx.response.status = :created
    end

    view do
      css_class CreateExpenseBox
      css_class Field
      css_class ButtonRow

      template do
        div CreateExpenseBox do
          h3 { "Neue Ausgabe" }
          form action: action.uri_path, method: "POST" do
            div Field do
              label { "Beschreibung:" }
              input type: :text, name: DESCRIPTION_FIELD, required: true
            end
            div Field do
              label { "Betrag in €:" }
              input type: :number, name: AMOUNT_FIELD, required: true, step: ".01"
            end
            div ButtonRow do
              button do
                "Speichern"
              end
            end
          end
        end
      end

      style do
        rule CreateExpenseBox do
          max_width 800.px
          margin 0.px, :auto
          margin_bottom 16.px
          padding 16.px
          border 1.px, :solid, :silver
          box_sizing :border_box
        end

        rule Field do
          display :flex
          justify_content :space_between
          margin_bottom 16.px
        end

        rule ButtonRow do
          display :flex
          justify_content :flex_end
        end
      end
    end
  end

  css_class ExpensesContainer
  css_class ExpensesSummaryBox
  css_class ExpensesSummaryLine

  style do
    rule ExpensesSummaryBox do
      max_width 800.px
      margin 0.px, :auto
      margin_bottom 16.px
      padding 16.px
      border 1.px, :solid, :silver
      box_sizing :border_box

      rule h3 do
        margin_top 0.px
        margin_bottom 8.px
      end
    end

    rule ExpensesSummaryLine do
      margin 0.px
    end

    rule ExpensesContainer do
      display :flex
      justify_content :flex_start
      flex_wrap :wrap
      gap 20.px
      margin_top 20.px
    end

    rule TopAppBarHeadlineWrapper do
      display :inline
    end

    rule TopAppBarHeadlineButton do
      background_color :transparent
      border :none
      padding 0.px
      color :inherit
      font_size :inherit
      font_weight :inherit
      cursor :pointer
    end
  end

  model_template :expenses_summary_view do
    div ExpensesSummaryBox do
      h3 { "Zusammenfassung" }

      if expenses.empty?
        p { "Noch keine Ausgaben." }
      else
        statements = expense_debt_statements
        if statements.empty?
          p { "Alle sind ausgeglichen." }
        else
          statements.each do |statement|
            div ExpensesSummaryLine do
              statement
            end
          end
        end
      end
    end
  end

  model_template :expenses_view do
    div ExpensesContainer do
      expenses.each do |expense|
        Crumble::Material::Card.new.to_html do
          Crumble::Material::Card::Title.new(expense.description)
          Crumble::Material::Card::SecondaryText.new.to_html do
            span do
              (expense.amount.to_f / 100).format(",", ".", decimal_places: 2)
              " € "
            end
            span do
              "bezahlt von "
            end
            strong do
              expense.group_membership.name
            end
          end
        end
      end
    end
  end

  model_template :members_list_view do
    Groups::MembersListView.new(ctx, model)
  end
end
