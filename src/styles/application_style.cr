style ApplicationStyle do
  rule body, button, input do
    font_family "Roboto"
  end

  rule a do
    color :black
    text_decoration :none
  end

  rule "[data-action]:not(input)" do
    cursor :pointer
  end

  rule "input[type=\"text\"]", "input[type=\"number\"]" do
    border :none
    border_bottom 1.px, :solid, :black
    background_color "#EEE"
    padding 8.px
    box_sizing :border_box
  end
end
