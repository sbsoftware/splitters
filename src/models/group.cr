require "./application_record"
require "./expense"
require "./group_membership"
require "./reimbursement"
require "./weight_template"
require "./weight_template_membership"
require "../resources/application_resource"

class Group < ApplicationRecord
  column name : String
  column created_at : Time
  column updated_at : Time

  has_many_of GroupMembership
  has_many_of Expense
  has_many_of Reimbursement
  has_many_of WeightTemplate

  css_class TopAppBarHeadlineWrapper
  css_class TopAppBarHeadlineButton

  def format_euros(amount_cents : Int32 | Int64) : String
    (amount_cents.to_f / 100).format(",", ".", decimal_places: 2)
  end

  def ledger_entries : Array(Expense | Reimbursement)
    entries = expenses.to_a + reimbursements.to_a
    entries.sort_by do |entry|
      # Explicit casts keep the compiler from widening this union to ApplicationRecord+
      if entry.is_a?(Expense)
        expense = entry.as(Expense)
        {expense.created_at.value, expense.id.value}
      else
        reimbursement = entry.as(Reimbursement)
        {reimbursement.created_at.value, reimbursement.id.value}
      end
    end.reverse!
  end

  def balances_with_reimbursements(memberships : Array(GroupMembership)) : Hash(Int64, Int32)
    member_weights = memberships.to_h { |gm| {gm.id.value, gm.weight.value} }
    balances = Hash(Int64, Int32).new(0)
    member_weights.keys.each { |member_id| balances[member_id] = 0 }

    template_weights_by_id = weight_template_weights_by_id(memberships, member_weights)
    default_template_id = default_weight_template.try(&.id.value)
    fallback_template_id = default_template_id || template_weights_by_id.keys.first?

    weighted_expenses = [] of MinimumCashFlow::WeightedExpense
    expenses.each do |expense|
      template_id = expense.effective_weight_template_id(fallback_template_id)
      member_weights_for_expense = template_id ? template_weights_by_id[template_id]? : nil
      member_weights_for_expense ||= member_weights

      weighted_expenses << MinimumCashFlow::WeightedExpense.new(
        paid_by_member_id: expense.group_membership_id.value,
        amount_cents: expense.amount.value,
        member_weights: member_weights_for_expense
      )
    end

    MinimumCashFlow
      .balances_from_weighted_expenses(weighted_expenses)
      .each do |member_id, balance|
        balances[member_id] = balance
      end

    reimbursements.each do |reimbursement|
      payer_id = reimbursement.payer_membership_id.value
      recipient_id = reimbursement.recipient_membership_id.value
      next unless balances.has_key?(payer_id) && balances.has_key?(recipient_id)

      amount = reimbursement.amount.value
      balances[payer_id] += amount
      balances[recipient_id] -= amount
    end

    balances
  end

  private def weight_template_weights_by_id(
    memberships : Array(GroupMembership),
    fallback_weights : Hash(Int64, Int32)
  ) : Hash(Int64, Hash(Int64, Int32))
    template_weights_by_id = {} of Int64 => Hash(Int64, Int32)

    weight_templates.to_a.each do |template|
      weights = fallback_weights.dup
      template.weight_template_memberships.each do |template_membership|
        member_id = template_membership.group_membership_id.value
        next unless weights.has_key?(member_id)

        weights[member_id] = template_membership.weight.value
      end
      template_weights_by_id[template.id.value] = weights
    end

    template_weights_by_id
  end

  def expense_debt_statements : Array(String)
    memberships = group_memberships.to_a
    return [] of String if memberships.size < 2

    membership_by_id = memberships.to_h { |gm| {gm.id.value, gm} }

    balances = balances_with_reimbursements(memberships)

    MinimumCashFlow
      .pairwise_debts_from_balances(balances)
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

  def default_weight_template : WeightTemplate?
    weight_templates.order_by_id!.first?
  end

  def default_weight_template_membership_for(membership : GroupMembership) : WeightTemplateMembership?
    return nil unless template = default_weight_template

    WeightTemplateMembership.where(weight_template_id: template.id, group_membership_id: membership.id).first?
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
    a href: GroupPage.uri_path(group_id: id) do
      Crumble::Material::Card.new.to_html do
        Crumble::Material::Card::Title.new(name)
        Crumble::Material::Card::SecondaryText.new.to_html do
          Crumble::Material::Icon.new("account_circle", "#{group_memberships.count} Mitglied(er)")
        end
      end
    end
  end

  css_class WeightTemplatesGrid
  css_class WeightTemplateCardLink

  model_template :weight_templates_list do
    div WeightTemplatesGrid do
      weight_templates.order_by_id!.each do |weight_template|
        a WeightTemplateCardLink, href: GroupWeightTemplatePage.uri_path(id, weight_template.id) do
          Crumble::Material::Card.new.to_html do
            Crumble::Material::Card::Title.new(weight_template.name)
            Crumble::Material::Card::SecondaryText.new.to_html do
              "#{weight_template.weight_template_memberships.count} Mitglied(er)"
            end
          end
        end
      end
    end
  end

  model_action :create_weight_template, weight_templates_list do
    NAME_FIELD = "name"

    css_class CreateTemplateInput
    css_class CreateTemplateButton

    form do
      field name : String

      def valid?
        super

        errors = @errors.not_nil!
        if (value = name) && value.strip.empty?
          errors << NAME_FIELD
        end

        errors.none?
      end

      def normalized_name : String?
        name.try(&.strip)
      end

      ToHtml.instance_template do
        input CreateTemplateInput, type: :text, name: NAME_FIELD, value: name.to_s, placeholder: "Name", required: true
      end
    end

    @submitted_form : Form? = nil

    def form
      @submitted_form || Form.new(ctx, name: "")
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

      @submitted_form = Form.from_www_form(ctx, body.gets_to_end)
      form = @submitted_form.not_nil!

      unless form.valid?
        ctx.response.status = :unprocessable_entity
        return
      end

      new_name = form.normalized_name
      return unless new_name

      template = WeightTemplate.create(
        membership_weight: WeightTemplate::DEFAULT_WEIGHT,
        group_id: model.id,
        name: new_name
      )

      redirect GroupWeightTemplatePage.uri_path(model.id, template.id)
    end

    view do
      template do
        action_form.to_html do
          button CreateTemplateButton, type: :submit do
            Crumble::Material::Icon.new("add")
          end
        end
      end

      style do
        rule CreateTemplateInput do
          flex_grow 1
          padding 8.px
          border 1.px, :solid, :silver
          border_radius 6.px
        end

        rule CreateTemplateButton do
          display :flex
          align_items :center
          justify_content :center
          width 40.px
          height 40.px
          border 1.px, :solid, :black
          border_radius 6.px
          background_color :white
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
      @submitted_form || Form.new(ctx, name: model.name.value)
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

      @submitted_form = Form.from_www_form(ctx, body.gets_to_end)
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

  create_child_action :create_expense, Expense, group_id, {expenses_view, expenses_summary_view} do
    DESCRIPTION_FIELD = "description"
    AMOUNT_FIELD      = "amount"

    form do
      field description : String
      field amount : Float64
    end

    def current_group_membership : GroupMembership?
      return nil unless user_id = ctx.session.user_id

      model.group_memberships.find do |group_membership|
        group_membership.user_id == user_id
      end
    end

    controller do
      unless body = ctx.request.body
        ctx.response.status = :bad_request
        return
      end

      form = begin
        Form.from_www_form(ctx, body.gets_to_end)
      rescue Exception
        ctx.response.status = :unprocessable_entity
        return
      end

      unless form.valid?
        ctx.response.status = :unprocessable_entity
        return
      end

      group_membership = current_group_membership
      description = form.description
      amount = form.amount

      unless group_membership && description && amount
        ctx.response.status = :unprocessable_entity
        return
      end

      amount_cents = (amount * 100).floor.to_i

      weight_template = model.default_weight_template || model.weight_templates.order_by_id!.first?
      unless weight_template
        ctx.response.status = :unprocessable_entity
        return
      end

      self.class.child_class.create(
        **parent_params,
        description: description,
        amount: amount_cents,
        group_membership_id: group_membership.id,
        weight_template_id: weight_template.id
      )

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

  create_child_action :create_reimbursement, Reimbursement, group_id, {expenses_view, expenses_summary_view} do
    AMOUNT_FIELD    = "amount"
    RECIPIENT_FIELD = "recipient_membership_id"

    form do
      field amount : Float64
      field recipient_membership_id : Int64
    end

    def current_group_membership : GroupMembership?
      return nil unless user_id = ctx.session.user_id

      model.group_memberships.find do |group_membership|
        group_membership.user_id == user_id
      end
    end

    controller do
      unless body = ctx.request.body
        ctx.response.status = :bad_request
        return
      end

      form = begin
        Form.from_www_form(ctx, body.gets_to_end)
      rescue Exception
        ctx.response.status = :unprocessable_entity
        return
      end

      unless form.valid?
        ctx.response.status = :unprocessable_entity
        return
      end

      group_membership = current_group_membership
      amount = form.amount
      recipient_id = form.recipient_membership_id

      unless group_membership && amount && recipient_id
        ctx.response.status = :unprocessable_entity
        return
      end

      recipient_membership = model.group_memberships.find { |gm| gm.id == recipient_id }
      unless recipient_membership && recipient_membership.id != group_membership.id
        ctx.response.status = :unprocessable_entity
        return
      end

      amount_cents = (amount * 100).floor.to_i

      self.class.child_class.create(
        **parent_params,
        payer_membership_id: group_membership.id,
        recipient_membership_id: recipient_membership.id,
        amount: amount_cents
      )

      ctx.response.status = :created
    end

    view do
      css_class ReimbursementToggle
      css_class ReimbursementToggleButton
      css_class ReimbursementToggleLabel
      css_class ReimbursementCaret
      css_class ReimbursementFormBox
      css_class ReimbursementField
      css_class ReimbursementButtonRow

      stimulus_controller ReimbursementToggleController do
        targets :form

        action :toggle do
          this.formTarget.hidden = !this.formTarget.hidden
        end
      end

      template do
        memberships = model.group_memberships.to_a
        current_membership = memberships.find { |membership| membership.user_id == ctx.session.user_id }
        other_memberships = if current_membership
                              memberships.reject { |membership| membership.id == current_membership.id }
                            else
                              memberships
                            end

        div ReimbursementToggle, ReimbursementToggleController do
          button ReimbursementToggleButton, ReimbursementToggleController.toggle_action("click"), type: :button do
            span ReimbursementToggleLabel do
              "Rückerstattung hinzufügen"
            end
            span ReimbursementCaret
          end

          form ReimbursementToggleController.form_target, ReimbursementFormBox, action: action.uri_path, method: "POST", hidden: true do
            div ReimbursementField do
              label { "Betrag in €:" }
              input type: :number, name: AMOUNT_FIELD, required: true, step: ".01"
            end
            div ReimbursementField do
              label { "An:" }
              select_tag name: RECIPIENT_FIELD, required: true do
                option(value: "") do
                  "Bitte auswählen"
                end
                other_memberships.each do |membership|
                  option(value: membership.id) do
                    membership.display_name
                  end
                end
              end
            end
            div ReimbursementButtonRow do
              button do
                "Speichern"
              end
            end
          end
        end
      end

      style do
        rule ReimbursementToggle do
          max_width 800.px
          margin 0.px, :auto
          margin_bottom 16.px
        end

        rule ReimbursementToggleButton do
          display :flex
          align_items :center
          gap 8.px
          background_color :transparent
          border :none
          padding 0.px
          font_size 1.rem
          cursor :pointer
        end

        rule ReimbursementCaret do
          width 0.px
          height 0.px
          border_left 6.px, :solid, "transparent"
          border_right 6.px, :solid, "transparent"
          border_top 8.px, :solid, "#333"
        end

        rule ReimbursementFormBox do
          margin_top 12.px
          padding 16.px
          border 1.px, :solid, :silver
          box_sizing :border_box
        end

        rule ReimbursementField do
          display :flex
          justify_content :space_between
          margin_bottom 16.px
        end

        rule ReimbursementButtonRow do
          display :flex
          justify_content :flex_end
        end
      end
    end
  end

  css_class ExpensesContainer
  css_class ExpensesSummaryBox
  css_class ExpensesSummaryLine
  css_class ExpensesSummaryTotal
  css_class ReimbursementCard

  style do
    EXPENSE_CARD_MIN_WIDTH = 376.px
    EXPENSE_CARD_MIN_HEIGHT = 128.px

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

    rule ExpensesSummaryTotal do
      margin 0.px
      margin_bottom 12.px
      font_weight :bold
    end

    rule ExpensesContainer do
      display :grid
      property(
        "grid-template-columns",
        "repeat(auto-fill, minmax(min(#{EXPENSE_CARD_MIN_WIDTH}, calc(100vw - 32px)), 1fr))"
      )
      property("justify-items", "center")
      gap 20.px
      margin_top 20.px
      width 100.percent
      box_sizing :border_box

      rule Crumble::Material::Card::Card do
        width EXPENSE_CARD_MIN_WIDTH
        min_height EXPENSE_CARD_MIN_HEIGHT
      end
    end

    rule ReimbursementCard do
      rule Crumble::Material::Card::Card do
        background_color "#d8f5d0"
      end
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

    rule WeightTemplatesGrid do
      padding 16.px
      display :grid
      property(
        "grid-template-columns",
        "repeat(auto-fill, minmax(min(320px, 100%), 1fr))"
      )
      gap 16.px
      box_sizing :border_box
    end

    rule WeightTemplateCardLink do
      display :block
      color :inherit
      text_decoration :none
    end
  end

  model_template :expenses_summary_view do
    div ExpensesSummaryBox do
      expenses_list = expenses.to_a
      entries = ledger_entries
      total_cents = expenses_list.sum(0_i64) { |expense| expense.amount.value.to_i64 }
      div ExpensesSummaryTotal do
        "Summe aller Ausgaben: #{format_euros(total_cents)} €"
      end

      if entries.empty?
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
      ledger_entries.each do |entry|
        if entry.is_a?(Expense)
          expense = entry.as(Expense)
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
            Crumble::Material::Card::SecondaryText.new.to_html do
              div Expense::ExpenseWeightTemplateLine do
                Crumble::Material::Icon.new("balance")
                expense.set_weight_template_action_template(ctx)
              end
            end
          end
        elsif entry.is_a?(Reimbursement)
          reimbursement = entry.as(Reimbursement)
          div ReimbursementCard do
            Crumble::Material::Card.new.to_html do
              payer = reimbursement.payer_membership.display_name
              recipient = reimbursement.recipient_membership.display_name
              amount = format_euros(reimbursement.amount.value)
              "#{payer} hat #{amount}€ an #{recipient} gezahlt"
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
