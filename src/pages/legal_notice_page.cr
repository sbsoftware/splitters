require "./application_page"

class LegalNoticePage < ApplicationPage
  css_class LegalNoticeHint
  css_class LegalNoticeColumns
  css_class LegalNoticeColumn

  style do
    rule LegalNoticeHint do
      font_weight 700
      background_color "#F7FAF6"
      border_left 4.px
      border_left_style :solid
      border_left_color :black
      padding 12.px
    end

    rule LegalNoticeColumns do
      display :grid
      grid_template_columns repeat(2, minmax(0, 1.fr))
      gap 0.px
      align_items :start
    end

    rule LegalNoticeColumn do
      min_width 0
    end

    rule LegalNoticeColumn <= CSS::NthOfType.new(1) do
      padding_right 32.px
    end

    rule LegalNoticeColumn <= CSS::NthOfType.new(2) do
      border_left 1.px
      border_left_style :solid
      border_left_color "#D8DED5"
      padding_left 32.px
    end

    media(max_width 760.px) do
      rule LegalNoticeColumns do
        grid_template_columns 1.fr
        gap 16.px
      end

      rule LegalNoticeColumn <= CSS::NthOfType.new(1) do
        padding_right 0.px
      end

      rule LegalNoticeColumn <= CSS::NthOfType.new(2) do
        border_left 0.px
        border_left_style :none
        border_top 1.px
        border_top_style :solid
        border_top_color "#D8DED5"
        padding_left 0.px
        padding_top 16.px
      end
    end
  end

  template do
    Crumble::Material::TopAppBar.new(
      leading_icon: Crumble::Material::NavigationDrawer::MenuSwitch,
      headline: "Splitters",
      trailing_icons: [] of Nil,
      type: :center_aligned
    )
    div ApplicationStyle::TextView do
      div LegalNoticeColumns do
        div LegalNoticeColumn do
          p LegalNoticeHint do
            "Die englische Übersetzung dient nur der besseren Verständlichkeit. Bei Auslegungsunterschieden ist die deutsche Version maßgeblich."
          end

          h1 { "Impressum" }

          p { "Angaben gemäß § 5 DDG" }
          p do
            span { legal_name }
            unless legal_name2.empty?
              br
              span { legal_name2 }
            end
            br
            span { legal_street }
            br
            span { legal_city }
            unless legal_country.empty?
              br
              span { legal_country }
            end
          end

          p do
            strong { "Vertreten durch: " }
            br
            span { legal_represented_by }
          end

          p do
            strong { "Kontakt:" }
            br
            span { "Telefon: #{legal_phone}" }
            unless legal_fax.empty?
              br
              span { "Fax: #{legal_fax}" }
            end
            br
            span { "E-Mail: " }
            a(href: "mailto:#{legal_email}") { legal_email }
          end

          p do
            strong { "Verbraucherstreitbeilegung / Universalschlichtungsstelle" }
            br
            span { "Wir nehmen nicht an Streitbeilegungsverfahren vor einer Verbraucherschlichtungsstelle teil und sind dazu auch nicht verpflichtet." }
          end

          p do
            strong { "Haftungsausschluss: " }
            br
            br
            strong { "Haftung für Inhalte" }
            br
            span { "Die Inhalte unserer Seiten wurden mit größter Sorgfalt erstellt. Für die Richtigkeit, Vollständigkeit und Aktualität der Inhalte können wir jedoch keine Gewähr übernehmen. Als Diensteanbieter sind wir gemäß § 7 Abs.1 DDG für eigene Inhalte auf diesen Seiten nach den allgemeinen Gesetzen verantwortlich. Nach §§ 8 bis 10 DDG sind wir als Diensteanbieter jedoch nicht verpflichtet, übermittelte oder gespeicherte fremde Informationen zu überwachen oder nach Umständen zu forschen, die auf eine rechtswidrige Tätigkeit hinweisen. Verpflichtungen zur Entfernung oder Sperrung der Nutzung von Informationen nach den allgemeinen Gesetzen bleiben hiervon unberührt. Eine diesbezügliche Haftung ist jedoch erst ab dem Zeitpunkt der Kenntnis einer konkreten Rechtsverletzung möglich. Bei Bekanntwerden von entsprechenden Rechtsverletzungen werden wir diese Inhalte umgehend entfernen." }
            br
            br
            strong { "Haftung für Links" }
            br
            span { "Unser Angebot enthält Links zu externen Webseiten Dritter, auf deren Inhalte wir keinen Einfluss haben. Deshalb können wir für diese fremden Inhalte auch keine Gewähr übernehmen. Für die Inhalte der verlinkten Seiten ist stets der jeweilige Anbieter oder Betreiber der Seiten verantwortlich. Die verlinkten Seiten wurden zum Zeitpunkt der Verlinkung auf mögliche Rechtsverstöße überprüft. Rechtswidrige Inhalte waren zum Zeitpunkt der Verlinkung nicht erkennbar. Eine permanente inhaltliche Kontrolle der verlinkten Seiten ist jedoch ohne konkrete Anhaltspunkte einer Rechtsverletzung nicht zumutbar. Bei Bekanntwerden von Rechtsverletzungen werden wir derartige Links umgehend entfernen." }
            br
            br
            strong { "Urheberrecht" }
            br
            span { "Die durch die Seitenbetreiber erstellten Inhalte und Werke auf diesen Seiten unterliegen dem deutschen Urheberrecht. Die Vervielfältigung, Bearbeitung, Verbreitung und jede Art der Verwertung außerhalb der Grenzen des Urheberrechtes bedürfen der schriftlichen Zustimmung des jeweiligen Autors bzw. Erstellers. Downloads und Kopien dieser Seite sind nur für den privaten, nicht kommerziellen Gebrauch gestattet. Soweit die Inhalte auf dieser Seite nicht vom Betreiber erstellt wurden, werden die Urheberrechte Dritter beachtet. Insbesondere werden Inhalte Dritter als solche gekennzeichnet. Sollten Sie trotzdem auf eine Urheberrechtsverletzung aufmerksam werden, bitten wir um einen entsprechenden Hinweis. Bei Bekanntwerden von Rechtsverletzungen werden wir derartige Inhalte umgehend entfernen." }
          end

          p do
            span { "Erstellt mit " }
            a(href: "https://impressum-generator.de", rel: "dofollow") { "Impressum-Generator.de" }
            span { ", dem Tool für Impressum und " }
            a(href: "https://impressum-generator.de/datenschutz-generator", rel: "dofollow") { "Datenschutz-Erklärung" }
            span { ". Nach einer Vorlage der " }
            a(href: "https://www.kanzlei-hasselbach.de/", rel: "dofollow") { "Kanzlei Hasselbach" }
            span { "." }
          end

          h2 { "Schriftarten (Font-Lizenzen)" }
          p do
            span { "Diese Anwendung nutzt unter anderem folgende Schriftarten:" }
            br
            a(href: Crumble::Material::RobotoLicense.uri_path) { "Roboto (LICENSE.txt)" }
            br
            a(href: Crumble::Material::Icon::FontLicense.uri_path) { "Material Symbols Outlined (LICENSE.txt)" }
          end
        end

        div LegalNoticeColumn do
          p LegalNoticeHint do
            "This English translation is provided for convenience only. In case of doubt, the German legal notice applies."
          end

          h1 { "Legal Notice" }

          p { "Information according to Section 5 DDG" }
          p do
            span { legal_name }
            unless legal_name2.empty?
              br
              span { legal_name2 }
            end
            br
            span { legal_street }
            br
            span { legal_city }
            unless legal_country.empty?
              br
              span { legal_country }
            end
          end

          p do
            strong { "Represented by: " }
            br
            span { legal_represented_by }
          end

          p do
            strong { "Contact:" }
            br
            span { "Phone: #{legal_phone}" }
            unless legal_fax.empty?
              br
              span { "Fax: #{legal_fax}" }
            end
            br
            span { "Email: " }
            a(href: "mailto:#{legal_email}") { legal_email }
          end

          p do
            strong { "Consumer dispute resolution / Universal Arbitration Board" }
            br
            span { "We do not participate in dispute resolution proceedings before a consumer arbitration board and are not obliged to do so." }
          end

          p do
            strong { "Disclaimer: " }
            br
            br
            strong { "Liability for content" }
            br
            span { "The content of our pages has been created with the greatest care. However, we cannot assume any liability for the accuracy, completeness, or timeliness of the content. As a service provider, we are responsible for our own content on these pages under Section 7 (1) DDG according to general laws. Under Sections 8 to 10 DDG, however, we as a service provider are not obliged to monitor transmitted or stored third-party information or to investigate circumstances that indicate unlawful activity. Obligations to remove or block the use of information under general laws remain unaffected. Liability in this respect is only possible from the time we become aware of a specific legal violation. If we become aware of corresponding legal violations, we will remove this content immediately." }
            br
            br
            strong { "Liability for links" }
            br
            span { "Our offer contains links to external third-party websites over whose content we have no influence. We therefore cannot assume any liability for this third-party content. The respective provider or operator of the linked pages is always responsible for their content. The linked pages were checked for possible legal violations at the time of linking. Unlawful content was not apparent at the time of linking. Permanent monitoring of the linked pages is not reasonable without specific indications of a legal violation. If we become aware of legal violations, we will remove such links immediately." }
            br
            br
            strong { "Copyright" }
            br
            span { "The content and works created by the site operators on these pages are subject to German copyright law. Reproduction, editing, distribution, and any kind of exploitation outside the limits of copyright law require the written consent of the respective author or creator. Downloads and copies of this site are permitted only for private, non-commercial use. Where content on this site was not created by the operator, third-party copyrights are respected. In particular, third-party content is identified as such. If you nevertheless become aware of a copyright infringement, please notify us accordingly. If we become aware of legal violations, we will remove such content immediately." }
          end

          p do
            span { "Created with " }
            a(href: "https://impressum-generator.de", rel: "dofollow") { "Impressum-Generator.de" }
            span { ", the tool for legal notices and " }
            a(href: "https://impressum-generator.de/datenschutz-generator", rel: "dofollow") { "privacy policies" }
            span { ". Based on a template by " }
            a(href: "https://www.kanzlei-hasselbach.de/", rel: "dofollow") { "Kanzlei Hasselbach" }
            span { "." }
          end

          h2 { "Fonts (Font Licenses)" }
          p do
            span { "This application uses, among others, the following fonts:" }
            br
            a(href: Crumble::Material::RobotoLicense.uri_path) { "Roboto (LICENSE.txt)" }
            br
            a(href: Crumble::Material::Icon::FontLicense.uri_path) { "Material Symbols Outlined (LICENSE.txt)" }
          end
        end
      end
    end
  end

  private def legal_name : String
    ENV.fetch("LEGAL_NOTICE_NAME")
  end

  private def legal_name2 : String
    ENV.fetch("LEGAL_NOTICE_NAME2", "")
  end

  private def legal_street : String
    ENV.fetch("LEGAL_NOTICE_STREET")
  end

  private def legal_city : String
    ENV.fetch("LEGAL_NOTICE_CITY")
  end

  private def legal_country : String
    ENV.fetch("LEGAL_NOTICE_COUNTRY")
  end

  private def legal_represented_by : String
    ENV.fetch("LEGAL_NOTICE_REPRESENTED_BY")
  end

  private def legal_phone : String
    ENV.fetch("LEGAL_NOTICE_PHONE")
  end

  private def legal_fax : String
    ENV.fetch("LEGAL_NOTICE_FAX", "")
  end

  private def legal_email : String
    ENV.fetch("LEGAL_NOTICE_EMAIL")
  end

  def window_title : String?
    "Legal notice"
  end
end
