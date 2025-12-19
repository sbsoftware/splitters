require "./application_record"
require "./group_membership"
require "../resources/application_resource"

class Group < ApplicationRecord
  column name : String
  column created_at : Time
  column updated_at : Time

  has_many_of GroupMembership
  has_many_of Expense

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
      css_class Field
      css_class ButtonRow

      template do
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

      style do
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
      max_width 600.px
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
end
