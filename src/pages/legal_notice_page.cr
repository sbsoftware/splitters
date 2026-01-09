class LegalNoticePage < ApplicationPage
  view do
    css_class LegalNoticeView
    css_class LicenseLink

    ToHtml.instance_template do
      div LegalNoticeView do
        h1 do
          "Impressum"
        end

        p do
          ENV.fetch("LEGAL_NOTICE_NAME")
          br
          ENV.fetch("LEGAL_NOTICE_STREET")
          br
          ENV.fetch("LEGAL_NOTICE_CITY")
        end

        h2 do
          "Kontakt"
        end
        p do
          "Telefon: #{ENV.fetch("LEGAL_NOTICE_PHONE")}"
          br
          "E-Mail: #{ENV.fetch("LEGAL_NOTICE_EMAIL")}"
        end

        h2 do
          "Verbraucher&shy;streit&shy;beilegung/Universal&shy;schlichtungs&shy;stelle"
        end
        p do
          "Wir sind nicht bereit oder verpflichtet, an Streitbeilegungsverfahren vor einer Verbraucherschlichtungsstelle teilzunehmen."
        end

        h2 do
          "Zentrale Kontaktstelle nach dem Digital Services Act - DSA (Verordnung (EU) 2022/265)"
        end
        p do
          "Unsere zentrale Kontaktstelle f&uuml;r Nutzer und Beh&ouml;rden nach Art. 11, 12 DSA erreichen Sie wie folgt:"
        end
        p do
          "E-Mail: #{ENV.fetch("LEGAL_NOTICE_DSA_EMAIL")}"
        end
        p do
          "Die f&uuml;r den Kontakt zur Verf&uuml;gung stehenden Sprachen sind: Deutsch, Englisch."
        end

        h2 do
          "Schriftlizenzen"
        end
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
