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
  end
end
