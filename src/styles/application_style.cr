class ApplicationStyle < CSS::Stylesheet
  rules do
    rule body, button do
      fontFamily "Roboto"
    end

    rule a do
      color Black
      textDecoration None
    end
  end
end
