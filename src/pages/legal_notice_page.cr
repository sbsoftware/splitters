class LegalNoticePage < ApplicationPage
  view do
    css_class LegalNoticeView
    css_class LicenseLink

    ToHtml.instance_template do
      div LegalNoticeView do
        a LicenseLink, href: Crumble::Material::RobotoLicense.uri_path do
          "Roboto font license"
        end
        br
        a LicenseLink, href: Crumble::Material::Icon::FontLicense.uri_path do
          "Material Symbols Outlined font license"
        end
      end
    end

    style do
      rule LegalNoticeView do
        padding 16.px
      end

      rule LicenseLink do
        color :black
        text_decoration :underline
      end
    end
  end
end
