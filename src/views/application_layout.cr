class ApplicationLayout < Crumble::Material::Layout
  def window_title
    "splitters.money"
  end

  def headline
    "Splitters"
  end

  class DrawerLink
    getter label : String
    getter href : String

    def initialize(@label, @href); end

    ToHtml.instance_template do
      a href: href do
        self.label
      end
    end
  end

  def drawer_headline
    DrawerLink.new(headline, HomePage.uri_path)
  end

  def drawer_items
    [
      DrawerLink.new("Legal notice", LegalNoticePage.uri_path),
      DrawerLink.new("Privacy notice", PrivacyNoticePage.uri_path),
    ]
  end
end
