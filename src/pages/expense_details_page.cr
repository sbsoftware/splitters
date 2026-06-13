class ExpenseDetailsPage < ApplicationPage
  root_path "/groups"
  model group : Group
  nested_path "/expenses"
  model expense : Expense

  before do
    unless user = ctx.session.user
      redirect HomePage.uri_path
      return 303
    end

    current_group = group.not_nil!
    unless current_group.group_memberships.any? { |membership| membership.user_id_value == user.id.value }
      redirect HomePage.uri_path
      return 303
    end

    current_expense = expense.not_nil!
    return 404 unless current_expense.group_id == current_group.id

    true
  end

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

    css_class Container
    css_class DetailsCard
    css_class Header
    css_class Label
    css_class Amount
    css_class Description
    css_class MetaLine
    css_class BalanceList
    css_class BalanceRow
    css_class BalanceName
    css_class BalanceAmount
    css_class BalanceAmountNegative

    def balance_amount(amount : Int32) : String
      "#{amount < 0 ? "-" : ""}#{group.format_euros(amount.abs)} €"
    end

    template do
      Crumble::Material::TopAppBar.new(
        leading_icon: BackLink.new(group),
        headline: "Ausgabe",
        trailing_icons: [] of Nil,
        type: :center_aligned
      )

      memberships = group.group_memberships.to_a
      balances = expense.member_balances(memberships)

      div Container do
        div DetailsCard do
          Crumble::Material::Card.new.to_html do
            div Header do
              span Label do
                "Ausgabe"
              end
              span Amount do
                "#{group.format_euros(expense.amount.value)} €"
              end
            end
            div Description do
              expense.description
            end
            Crumble::Material::Card::SecondaryText.new.to_html do
              div MetaLine do
                span do
                  "bezahlt von "
                end
                strong do
                  expense.group_membership.display_name
                end
              end
            end
            Crumble::Material::Card::SecondaryText.new.to_html do
              div MetaLine do
                Crumble::Material::Icon.new("balance")
                span do
                  if template_id = expense.effective_weight_template_id(group.default_weight_template.try(&.id.value))
                    WeightTemplate.find(template_id).name
                  else
                    "Keine Gewichtung"
                  end
                end
              end
            end
          end
        end

        div BalanceList do
          memberships.each do |membership|
            balance = balances[membership.id.value]
            div BalanceRow do
              span BalanceName do
                membership.display_name
              end
              span BalanceAmount, (BalanceAmountNegative if balance < 0) do
                balance_amount(balance)
              end
            end
          end
        end
      end
    end

    style do
      rule Container do
        padding 16.px
        box_sizing :border_box
        max_width 800.px
        margin 0.px, :auto
      end

      rule DetailsCard do
        width 100.percent
        max_width 360.px
        margin 0.px, :auto
        margin_bottom 16.px
      end

      rule Header do
        display :flex
        justify_content :space_between
        align_items :flex_start
        gap 10.px
      end

      rule Label do
        font_weight :bold
        color "#2f5a33"
        property("text-transform", "uppercase")
        font_size 0.78.rem
        letter_spacing 0.04.em
      end

      rule Amount do
        font_weight :bold
        font_size 0.95.rem
        color "#1f3d23"
        white_space :nowrap
      end

      rule Description do
        font_weight :bold
        color "#1f3d23"
        margin_top 4.px
        margin_bottom 2.px
      end

      rule MetaLine do
        display :flex
        align_items :center
        gap 6.px
        flex_wrap :wrap
      end

      rule BalanceList do
        display :flex
        flex_direction :column
        gap 8.px
      end

      rule BalanceRow do
        display :flex
        justify_content :space_between
        align_items :center
        gap 12.px
        padding 10.px, 12.px
        border 1.px, :solid, "#dce2ee"
        border_radius 8.px
        background_color :white
      end

      rule BalanceName do
        font_weight :bold
      end

      rule BalanceAmount do
        font_weight :bold
        color "#2f5a33"
        white_space :nowrap
      end

      rule BalanceAmountNegative do
        color "#8f1f1f"
      end
    end
  end
end
