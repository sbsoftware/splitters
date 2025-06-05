class ApplicationStyle < CSS::Stylesheet
  rules do
    rule body, button, input do
      fontFamily "Roboto"
    end

    rule a do
      color Black
      textDecoration None
    end

    rule "[data-action]" do
      prop("cursor", "pointer")
    end

    rule "input[type=\"text\"]", "input[type=\"number\"]" do
      prop("border", "none")
      prop("border-bottom", "1px solid black")
      backgroundColor "#EEE"
      padding 8.px
      prop("box-sizing", "border-box")
    end
  end
end
