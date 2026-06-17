require "./application_page"

css_id PrivacyPreambleId
css_id PrivacyControllerId
css_id PrivacyProcessingOverviewId
css_id PrivacyLegalBasesId
css_id PrivacySecurityMeasuresId
css_id PrivacyPersonalDataTransferId
css_id PrivacyInternationalTransfersId
css_id PrivacyRetentionDeletionId
css_id PrivacyDataSubjectRightsId
css_id PrivacyWebhostingId
css_id PrivacyCookiesId
css_id PrivacyUserAccountId
css_id PrivacyContactRequestsId
css_id PrivacyEmbeddedContentId
css_id PrivacyChangesId
css_id PrivacyDefinitionsId
css_id PrivacyEnglishPreambleId
css_id PrivacyEnglishControllerId
css_id PrivacyEnglishProcessingOverviewId
css_id PrivacyEnglishLegalBasesId
css_id PrivacyEnglishSecurityMeasuresId
css_id PrivacyEnglishPersonalDataTransferId
css_id PrivacyEnglishInternationalTransfersId
css_id PrivacyEnglishRetentionDeletionId
css_id PrivacyEnglishDataSubjectRightsId
css_id PrivacyEnglishWebhostingId
css_id PrivacyEnglishCookiesId
css_id PrivacyEnglishUserAccountId
css_id PrivacyEnglishContactRequestsId
css_id PrivacyEnglishEmbeddedContentId
css_id PrivacyEnglishChangesId
css_id PrivacyEnglishDefinitionsId

class PrivacyNoticePage < ApplicationPage
  css_class DataPrivacyNoticeHint
  css_class DataPrivacyNoticeColumns
  css_class DataPrivacyNoticeColumn
  css_class DataPrivacyNoticeOriginal
  css_class DataPrivacyNoticeTranslation
  css_class DataPrivacyNoticeIndex
  css_class DataPrivacyNoticeMetaList
  css_class DataPrivacyNoticeSeal

  style do
    rule DataPrivacyNoticeHint do
      font_weight 700
      background_color "#F7FAF6"
      border_left 4.px
      border_left_style :solid
      border_left_color :black
      padding 12.px
    end

    rule DataPrivacyNoticeColumns do
      display :grid
      grid_template_columns repeat(2, minmax(0, 1.fr))
      gap 0.px
      align_items :stretch
    end

    rule DataPrivacyNoticeColumn do
      min_width 0
    end

    rule DataPrivacyNoticeOriginal do
      padding_right 32.px
    end

    rule DataPrivacyNoticeTranslation do
      border_left 1.px
      border_left_style :solid
      border_left_color "#D8DED5"
      padding_left 32.px
    end

    rule DataPrivacyNoticeIndex do
      padding_left 20.px
    end

    rule DataPrivacyNoticeMetaList do
      padding_left 20.px
    end

    rule DataPrivacyNoticeSeal do
      font_size 0.9.rem
    end

    media(max_width 760.px) do
      rule DataPrivacyNoticeColumns do
        grid_template_columns 1.fr
        gap 16.px
      end

      rule DataPrivacyNoticeOriginal do
        order 1
        padding_right 0.px
      end

      rule DataPrivacyNoticeTranslation do
        order 2
        border_left 0.px
        border_left_style :none
        border_top 0.px
        border_top_style :none
        padding_left 0.px
        padding_top 0.px
      end

      rule DataPrivacyNoticeTranslation <= CSS::NthOfType.new(2) do
        border_top 1.px
        border_top_style :solid
        border_top_color "#D8DED5"
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
      div DataPrivacyNoticeColumns do
        div DataPrivacyNoticeColumn, DataPrivacyNoticeOriginal do
          p DataPrivacyNoticeHint do
            "Die englische Übersetzung dient nur der besseren Verständlichkeit. Bei Auslegungsunterschieden ist die deutsche Version maßgeblich."
          end

          h1 { "Datenschutzerklärung" }
          h2 PrivacyPreambleId do
            "Präambel"
          end
          p { "Mit der folgenden Datenschutzerklärung möchten wir Sie darüber aufklären, welche Arten Ihrer personenbezogenen Daten (nachfolgend auch kurz als \"Daten\" bezeichnet) wir zu welchen Zwecken und in welchem Umfang verarbeiten. Die Datenschutzerklärung gilt für alle von uns durchgeführten Verarbeitungen personenbezogener Daten, sowohl im Rahmen der Erbringung unserer Leistungen als auch insbesondere auf unseren Webseiten, in mobilen Applikationen sowie innerhalb externer Onlinepräsenzen, wie z. B. unserer Social-Media-Profile (nachfolgend zusammenfassend bezeichnet als \"Onlineangebot\")." }
          p { "Die verwendeten Begriffe sind nicht geschlechtsspezifisch." }
          p { "Stand: 13. Mai 2026" }

          h2 { "Inhaltsübersicht" }
          ul DataPrivacyNoticeIndex do
            li do
              a(href: "##{PrivacyPreambleId}") { "Präambel" }
            end
            li do
              a(href: "##{PrivacyControllerId}") { "Verantwortlicher" }
            end
            li do
              a(href: "##{PrivacyProcessingOverviewId}") { "Übersicht der Verarbeitungen" }
            end
            li do
              a(href: "##{PrivacyLegalBasesId}") { "Maßgebliche Rechtsgrundlagen" }
            end
            li do
              a(href: "##{PrivacySecurityMeasuresId}") { "Sicherheitsmaßnahmen" }
            end
            li do
              a(href: "##{PrivacyPersonalDataTransferId}") { "Übermittlung von personenbezogenen Daten" }
            end
            li do
              a(href: "##{PrivacyInternationalTransfersId}") { "Internationale Datentransfers" }
            end
            li do
              a(href: "##{PrivacyRetentionDeletionId}") { "Allgemeine Informationen zur Datenspeicherung und Löschung" }
            end
            li do
              a(href: "##{PrivacyDataSubjectRightsId}") { "Rechte der betroffenen Personen" }
            end
            li do
              a(href: "##{PrivacyWebhostingId}") { "Bereitstellung des Onlineangebots und Webhosting" }
            end
            li do
              a(href: "##{PrivacyCookiesId}") { "Einsatz von Cookies" }
            end
            li do
              a(href: "##{PrivacyUserAccountId}") { "Registrierung, Anmeldung und Nutzerkonto" }
            end
            li do
              a(href: "##{PrivacyContactRequestsId}") { "Kontakt- und Anfrageverwaltung" }
            end
            li do
              a(href: "##{PrivacyEmbeddedContentId}") { "Plug-ins und eingebettete Funktionen sowie Inhalte" }
            end
            li do
              a(href: "##{PrivacyChangesId}") { "Änderung und Aktualisierung" }
            end
            li do
              a(href: "##{PrivacyDefinitionsId}") { "Begriffsdefinitionen" }
            end
          end
        end

        div DataPrivacyNoticeColumn, DataPrivacyNoticeTranslation do
          p DataPrivacyNoticeHint do
            "This English translation is provided for convenience only. In case of doubt, the German privacy policy applies."
          end

          h1 { "Privacy Policy" }
          h2 PrivacyEnglishPreambleId do
            "Preamble"
          end
          p { "With the following privacy policy, we would like to inform you about which types of your personal data (hereinafter also referred to briefly as \"data\") we process, for which purposes, and to what extent. The privacy policy applies to all processing of personal data carried out by us, both in the context of providing our services and, in particular, on our websites, in mobile applications, and within external online presences, such as our social media profiles (hereinafter collectively referred to as the \"online offering\")." }
          p { "The terms used are not gender-specific." }
          p { "As of: May 13, 2026" }

          h2 { "Table of Contents" }
          ul DataPrivacyNoticeIndex do
            li do
              a(href: "##{PrivacyEnglishPreambleId}") { "Preamble" }
            end
            li do
              a(href: "##{PrivacyEnglishControllerId}") { "Controller" }
            end
            li do
              a(href: "##{PrivacyEnglishProcessingOverviewId}") { "Overview of Processing" }
            end
            li do
              a(href: "##{PrivacyEnglishLegalBasesId}") { "Relevant Legal Bases" }
            end
            li do
              a(href: "##{PrivacyEnglishSecurityMeasuresId}") { "Security Measures" }
            end
            li do
              a(href: "##{PrivacyEnglishPersonalDataTransferId}") { "Transfer of Personal Data" }
            end
            li do
              a(href: "##{PrivacyEnglishInternationalTransfersId}") { "International Data Transfers" }
            end
            li do
              a(href: "##{PrivacyEnglishRetentionDeletionId}") { "General Information on Data Retention and Deletion" }
            end
            li do
              a(href: "##{PrivacyEnglishDataSubjectRightsId}") { "Rights of Data Subjects" }
            end
            li do
              a(href: "##{PrivacyEnglishWebhostingId}") { "Provision of the Online Offering and Web Hosting" }
            end
            li do
              a(href: "##{PrivacyEnglishCookiesId}") { "Use of Cookies" }
            end
            li do
              a(href: "##{PrivacyEnglishUserAccountId}") { "Registration, Login, and User Account" }
            end
            li do
              a(href: "##{PrivacyEnglishContactRequestsId}") { "Contact and Request Management" }
            end
            li do
              a(href: "##{PrivacyEnglishEmbeddedContentId}") { "Plug-ins, Embedded Functions, and Content" }
            end
            li do
              a(href: "##{PrivacyEnglishChangesId}") { "Changes and Updates" }
            end
            li do
              a(href: "##{PrivacyEnglishDefinitionsId}") { "Definitions" }
            end
          end
        end

        div DataPrivacyNoticeColumn, DataPrivacyNoticeOriginal do
          h2 PrivacyControllerId do
            "Verantwortlicher"
          end
          controller_address("E-Mail-Adresse")
        end

        div DataPrivacyNoticeColumn, DataPrivacyNoticeTranslation do
          h2 PrivacyEnglishControllerId do
            "Controller"
          end
          controller_address("Email address")
        end

        div DataPrivacyNoticeColumn, DataPrivacyNoticeOriginal do
          h2 PrivacyProcessingOverviewId do
            "Übersicht der Verarbeitungen"
          end
          p { "Die nachfolgende Übersicht fasst die Arten der verarbeiteten Daten und die Zwecke ihrer Verarbeitung zusammen und verweist auf die betroffenen Personen." }
          h3 { "Arten der verarbeiteten Daten" }
          ul do
            li { "Bestandsdaten." }
            li { "Beschäftigtendaten." }
            li { "Kontaktdaten." }
            li { "Inhaltsdaten." }
            li { "Nutzungsdaten." }
            li { "Meta-, Kommunikations- und Verfahrensdaten." }
            li { "Protokolldaten." }
          end
          h3 { "Kategorien betroffener Personen" }
          ul do
            li { "Beschäftigte." }
            li { "Kommunikationspartner." }
            li { "Nutzer." }
            li { "Dritte Personen." }
            li { "Hinweisgeber." }
          end
          h3 { "Zwecke der Verarbeitung" }
          ul do
            li { "Erbringung vertraglicher Leistungen und Erfüllung vertraglicher Pflichten." }
            li { "Kommunikation." }
            li { "Sicherheitsmaßnahmen." }
            li { "Organisations- und Verwaltungsverfahren." }
            li { "Servermonitoring und Fehlererkennung." }
            li { "Feedback." }
            li { "Bereitstellung unseres Onlineangebotes und Nutzerfreundlichkeit." }
            li { "Informationstechnische Infrastruktur." }
            li { "Hinweisgeberschutz." }
          end
        end

        div DataPrivacyNoticeColumn, DataPrivacyNoticeTranslation do
          h2 PrivacyEnglishProcessingOverviewId do
            "Overview of Processing"
          end
          p { "The following overview summarizes the types of data processed and the purposes of their processing and refers to the persons concerned." }
          h3 { "Types of Processed Data" }
          ul do
            li { "Inventory data." }
            li { "Employee data." }
            li { "Contact data." }
            li { "Content data." }
            li { "Usage data." }
            li { "Meta, communication, and procedural data." }
            li { "Log data." }
          end
          h3 { "Categories of Data Subjects" }
          ul do
            li { "Employees." }
            li { "Communication partners." }
            li { "Users." }
            li { "Third persons." }
            li { "Whistleblowers." }
          end
          h3 { "Purposes of Processing" }
          ul do
            li { "Provision of contractual services and fulfillment of contractual obligations." }
            li { "Communication." }
            li { "Security measures." }
            li { "Organizational and administrative procedures." }
            li { "Server monitoring and error detection." }
            li { "Feedback." }
            li { "Provision of our online offering and user-friendliness." }
            li { "Information technology infrastructure." }
            li { "Whistleblower protection." }
          end
        end

        div DataPrivacyNoticeColumn, DataPrivacyNoticeOriginal do
          h2 PrivacyLegalBasesId do
            "Maßgebliche Rechtsgrundlagen"
          end
          p do
            strong { "Maßgebliche Rechtsgrundlagen nach der DSGVO: " }
            span { "Im Folgenden erhalten Sie eine Übersicht der Rechtsgrundlagen der DSGVO, auf deren Basis wir personenbezogene Daten verarbeiten. Bitte nehmen Sie zur Kenntnis, dass neben den Regelungen der DSGVO nationale Datenschutzvorgaben in Ihrem bzw. unserem Wohn- oder Sitzland gelten können. Sollten ferner im Einzelfall speziellere Rechtsgrundlagen maßgeblich sein, teilen wir Ihnen diese in der Datenschutzerklärung mit." }
          end
          ul do
            li { strong { "Einwilligung (Art. 6 Abs. 1 S. 1 lit. a) DSGVO)" }; span { " - Die betroffene Person hat ihre Einwilligung in die Verarbeitung der sie betreffenden personenbezogenen Daten für einen spezifischen Zweck oder mehrere bestimmte Zwecke gegeben." } }
            li { strong { "Vertragserfüllung und vorvertragliche Anfragen (Art. 6 Abs. 1 S. 1 lit. b) DSGVO)" }; span { " - Die Verarbeitung ist für die Erfüllung eines Vertrags, dessen Vertragspartei die betroffene Person ist, oder zur Durchführung vorvertraglicher Maßnahmen erforderlich, die auf Anfrage der betroffenen Person erfolgen." } }
            li { strong { "Rechtliche Verpflichtung (Art. 6 Abs. 1 S. 1 lit. c) DSGVO)" }; span { " - Die Verarbeitung ist zur Erfüllung einer rechtlichen Verpflichtung erforderlich, der der Verantwortliche unterliegt." } }
            li { strong { "Berechtigte Interessen (Art. 6 Abs. 1 S. 1 lit. f) DSGVO)" }; span { " - die Verarbeitung ist zur Wahrung der berechtigten Interessen des Verantwortlichen oder eines Dritten notwendig, vorausgesetzt, dass die Interessen, Grundrechte und Grundfreiheiten der betroffenen Person, die den Schutz personenbezogener Daten verlangen, nicht überwiegen." } }
          end
          p do
            strong { "Nationale Datenschutzregelungen in Deutschland: " }
            span { "Zusätzlich zu den Datenschutzregelungen der DSGVO gelten nationale Regelungen zum Datenschutz in Deutschland. Hierzu gehört insbesondere das Gesetz zum Schutz vor Missbrauch personenbezogener Daten bei der Datenverarbeitung (Bundesdatenschutzgesetz - BDSG). Das BDSG enthält insbesondere Spezialregelungen zum Recht auf Auskunft, zum Recht auf Löschung, zum Widerspruchsrecht, zur Verarbeitung besonderer Kategorien personenbezogener Daten, zur Verarbeitung für andere Zwecke und zur Übermittlung sowie automatisierten Entscheidungsfindung im Einzelfall einschließlich Profiling. Ferner können Landesdatenschutzgesetze der einzelnen Bundesländer zur Anwendung gelangen." }
          end
        end

        div DataPrivacyNoticeColumn, DataPrivacyNoticeTranslation do
          h2 PrivacyEnglishLegalBasesId do
            "Relevant Legal Bases"
          end
          p do
            strong { "Relevant legal bases under the GDPR: " }
            span { "In the following, you will receive an overview of the legal bases of the GDPR on the basis of which we process personal data. Please note that, in addition to the provisions of the GDPR, national data protection requirements in your or our country of residence or registered office may apply. Should more specific legal bases also be relevant in individual cases, we will inform you of them in the privacy policy." }
          end
          ul do
            li { strong { "Consent (Art. 6(1)(a) GDPR)" }; span { " - The data subject has given their consent to the processing of personal data concerning them for a specific purpose or several specific purposes." } }
            li { strong { "Performance of a contract and pre-contractual requests (Art. 6(1)(b) GDPR)" }; span { " - Processing is necessary for the performance of a contract to which the data subject is a party or for the implementation of pre-contractual measures that are carried out at the request of the data subject." } }
            li { strong { "Legal obligation (Art. 6(1)(c) GDPR)" }; span { " - Processing is necessary for compliance with a legal obligation to which the controller is subject." } }
            li { strong { "Legitimate interests (Art. 6(1)(f) GDPR)" }; span { " - processing is necessary for the purposes of the legitimate interests pursued by the controller or by a third party, provided that the interests, fundamental rights, and fundamental freedoms of the data subject that require the protection of personal data do not override them." } }
          end
          p do
            strong { "National data protection regulations in Germany: " }
            span { "In addition to the data protection regulations of the GDPR, national regulations on data protection apply in Germany. This includes, in particular, the law on protection against misuse of personal data in data processing (Federal Data Protection Act - BDSG). In particular, the BDSG contains special regulations on the right of access, the right to erasure, the right to object, the processing of special categories of personal data, processing for other purposes, and transmission as well as automated decision-making in individual cases, including profiling. Furthermore, state data protection laws of the individual German federal states may apply." }
          end
        end

        div DataPrivacyNoticeColumn, DataPrivacyNoticeOriginal do
          h2 PrivacySecurityMeasuresId do
            "Sicherheitsmaßnahmen"
          end
          p { "Wir treffen nach Maßgabe der gesetzlichen Vorgaben unter Berücksichtigung des Stands der Technik, der Implementierungskosten und der Art, des Umfangs, der Umstände und der Zwecke der Verarbeitung sowie der unterschiedlichen Eintrittswahrscheinlichkeiten und des Ausmaßes der Bedrohung der Rechte und Freiheiten natürlicher Personen geeignete technische und organisatorische Maßnahmen, um ein dem Risiko angemessenes Schutzniveau zu gewährleisten." }
          p { "Zu den Maßnahmen gehören insbesondere die Sicherung der Vertraulichkeit, Integrität und Verfügbarkeit von Daten durch Kontrolle des physischen und elektronischen Zugangs zu den Daten als auch des sie betreffenden Zugriffs, der Eingabe, der Weitergabe, der Sicherung der Verfügbarkeit und ihrer Trennung. Des Weiteren haben wir Verfahren eingerichtet, die eine Wahrnehmung von Betroffenenrechten, die Löschung von Daten und Reaktionen auf die Gefährdung der Daten gewährleisten. Ferner berücksichtigen wir den Schutz personenbezogener Daten bereits bei der Entwicklung bzw. Auswahl von Hardware, Software sowie Verfahren entsprechend dem Prinzip des Datenschutzes, durch Technikgestaltung und durch datenschutzfreundliche Voreinstellungen." }
          p { "Sicherung von Online-Verbindungen durch TLS-/SSL-Verschlüsselungstechnologie (HTTPS): Um die Daten der Nutzer, die über unsere Online-Dienste übertragen werden, vor unerlaubten Zugriffen zu schützen, setzen wir auf die TLS-/SSL-Verschlüsselungstechnologie. Secure Sockets Layer (SSL) und Transport Layer Security (TLS) sind die Eckpfeiler der sicheren Datenübertragung im Internet. Diese Technologien verschlüsseln die Informationen, die zwischen der Website oder App und dem Browser des Nutzers (oder zwischen zwei Servern) übertragen werden, wodurch die Daten vor unbefugtem Zugriff geschützt sind. TLS, als die weiterentwickelte und sicherere Version von SSL, gewährleistet, dass alle Datenübertragungen den höchsten Sicherheitsstandards entsprechen. Wenn eine Website durch ein SSL-/TLS-Zertifikat gesichert ist, wird dies durch die Anzeige von HTTPS in der URL signalisiert. Dies dient als ein Indikator für die Nutzer, dass ihre Daten sicher und verschlüsselt übertragen werden." }
        end

        div DataPrivacyNoticeColumn, DataPrivacyNoticeTranslation do
          h2 PrivacyEnglishSecurityMeasuresId do
            "Security Measures"
          end
          p { "In accordance with the legal requirements, taking into account the state of the art, the implementation costs, and the nature, scope, circumstances, and purposes of processing as well as the different likelihoods of occurrence and the extent of the threat to the rights and freedoms of natural persons, we take appropriate technical and organizational measures to ensure a level of protection appropriate to the risk." }
          p { "The measures include, in particular, securing the confidentiality, integrity, and availability of data by controlling physical and electronic access to the data as well as access concerning the data, input, disclosure, securing availability, and separation. Furthermore, we have established procedures that ensure the exercise of data subject rights, the deletion of data, and responses to the endangerment of the data. In addition, we take the protection of personal data into account already during the development or selection of hardware, software, and procedures in accordance with the principle of data protection, through technology design and through privacy-friendly default settings." }
          p { "Securing online connections through TLS/SSL encryption technology (HTTPS): To protect the users' data that is transmitted via our online services against unauthorized access, we rely on TLS/SSL encryption technology. Secure Sockets Layer (SSL) and Transport Layer Security (TLS) are the cornerstones of secure data transmission on the internet. These technologies encrypt the information that is transmitted between the website or app and the user's browser (or between two servers), whereby the data is protected against unauthorized access. TLS, as the further developed and more secure version of SSL, ensures that all data transmissions comply with the highest security standards. If a website is secured by an SSL/TLS certificate, this is signaled by the display of HTTPS in the URL. This serves as an indicator for users that their data is transmitted securely and encrypted." }
        end

        div DataPrivacyNoticeColumn, DataPrivacyNoticeOriginal do
          h2 PrivacyPersonalDataTransferId do
            "Übermittlung von personenbezogenen Daten"
          end
          p { "Im Rahmen unserer Verarbeitung von personenbezogenen Daten kommt es vor, dass diese an andere Stellen, Unternehmen, rechtlich selbstständige Organisationseinheiten oder Personen übermittelt beziehungsweise ihnen gegenüber offengelegt werden. Zu den Empfängern dieser Daten können z. B. mit IT-Aufgaben beauftragte Dienstleister gehören oder Anbieter von Diensten und Inhalten, die in eine Website eingebunden sind. In solchen Fällen beachten wir die gesetzlichen Vorgaben und schließen insbesondere entsprechende Verträge bzw. Vereinbarungen, die dem Schutz Ihrer Daten dienen, mit den Empfängern Ihrer Daten ab." }
        end

        div DataPrivacyNoticeColumn, DataPrivacyNoticeTranslation do
          h2 PrivacyEnglishPersonalDataTransferId do
            "Transfer of Personal Data"
          end
          p { "In the context of our processing of personal data, it may occur that this data is transmitted to other bodies, companies, legally independent organizational units, or persons, or disclosed to them. The recipients of this data may include, for example, service providers entrusted with IT tasks or providers of services and content that are integrated into a website. In such cases, we observe the legal requirements and, in particular, conclude corresponding contracts or agreements that serve to protect your data with the recipients of your data." }
        end

        div DataPrivacyNoticeColumn, DataPrivacyNoticeOriginal do
          h2 PrivacyInternationalTransfersId do
            "Internationale Datentransfers"
          end
          p { "Datenverarbeitung in Drittländern: Sofern wir Daten in ein Drittland (d. h. außerhalb der Europäischen Union (EU) oder des Europäischen Wirtschaftsraums (EWR)) übermitteln oder dies im Rahmen der Nutzung von Diensten Dritter oder der Offenlegung bzw. Übermittlung von Daten an andere Personen, Stellen oder Unternehmen geschieht (was erkennbar wird anhand der Postadresse des jeweiligen Anbieters oder wenn in der Datenschutzerklärung ausdrücklich auf den Datentransfer in Drittländer hingewiesen wird), erfolgt dies stets im Einklang mit den gesetzlichen Vorgaben." }
          p { "Für Datenübermittlungen in die USA stützen wir uns vorrangig auf das Data Privacy Framework (DPF), welches durch einen Angemessenheitsbeschluss der EU-Kommission vom 10.07.2023 als sicherer Rechtsrahmen anerkannt wurde. Zusätzlich haben wir mit den jeweiligen Anbietern Standardvertragsklauseln abgeschlossen, die den Vorgaben der EU-Kommission entsprechen und vertragliche Verpflichtungen zum Schutz Ihrer Daten festlegen." }
          p { "Diese zweifache Absicherung gewährleistet einen umfassenden Schutz Ihrer Daten: Das DPF bildet die primäre Schutzebene, während die Standardvertragsklauseln als zusätzliche Sicherheit dienen. Sollten sich Änderungen im Rahmen des DPF ergeben, greifen die Standardvertragsklauseln als zuverlässige Rückfalloption ein. So stellen wir sicher, dass Ihre Daten auch bei etwaigen politischen oder rechtlichen Veränderungen stets angemessen geschützt bleiben." }
          p do
            span { "Bei den einzelnen Diensteanbietern informieren wir Sie darüber, ob sie nach dem DPF zertifiziert sind und ob Standardvertragsklauseln vorliegen. Weitere Informationen zum DPF und eine Liste der zertifizierten Unternehmen finden Sie auf der Website des US-Handelsministeriums unter " }
            a(href: "https://www.dataprivacyframework.gov/", target: "_blank") { "https://www.dataprivacyframework.gov/" }
            span { " (in englischer Sprache)." }
          end
          p do
            span { "Für Datenübermittlungen in andere Drittländer gelten entsprechende Sicherheitsmaßnahmen, insbesondere Standardvertragsklauseln, ausdrückliche Einwilligungen oder gesetzlich erforderliche Übermittlungen. Informationen zu Drittlandtransfers und geltenden Angemessenheitsbeschlüssen können Sie dem Informationsangebot der EU-Kommission entnehmen: " }
            a(href: "https://commission.europa.eu/law/law-topic/data-protection/international-dimension-data-protection_en?prefLang=de", target: "_blank") { "https://commission.europa.eu/law/law-topic/data-protection/international-dimension-data-protection_en?prefLang=de." }
          end
        end

        div DataPrivacyNoticeColumn, DataPrivacyNoticeTranslation do
          h2 PrivacyEnglishInternationalTransfersId do
            "International Data Transfers"
          end
          p { "Data processing in third countries: If we transfer data to a third country, i.e. outside the European Union (EU) or the European Economic Area (EEA), or if this happens in the context of the use of third-party services or the disclosure or transfer of data to other persons, bodies, or companies (which becomes recognizable from the postal address of the respective provider or when the privacy policy expressly points out the data transfer to third countries), this always takes place in accordance with the legal requirements." }
          p { "For data transfers to the USA, we primarily base ourselves on the Data Privacy Framework (DPF), which was recognized as a secure legal framework by an adequacy decision of the EU Commission of July 10, 2023. In addition, we have concluded standard contractual clauses with the respective providers, which comply with the requirements of the EU Commission and establish contractual obligations to protect your data." }
          p { "This dual safeguard ensures comprehensive protection of your data: The DPF forms the primary protection level, while the standard contractual clauses serve as additional security. Should changes arise within the framework of the DPF, the standard contractual clauses take effect as a reliable fallback option. In this way, we ensure that your data always remains adequately protected even in the event of possible political or legal changes." }
          p do
            span { "For the individual service providers, we inform you whether they are certified under the DPF and whether standard contractual clauses are in place. Further information about the DPF and a list of certified companies can be found on the website of the U.S. Department of Commerce at " }
            a(href: "https://www.dataprivacyframework.gov/", target: "_blank") { "https://www.dataprivacyframework.gov/" }
            span { " (in English)." }
          end
          p do
            span { "For data transfers to other third countries, corresponding security measures apply, in particular standard contractual clauses, explicit consents, or legally required transfers. Information on third-country transfers and applicable adequacy decisions can be taken from the information offering of the EU Commission: " }
            a(href: "https://commission.europa.eu/law/law-topic/data-protection/international-dimension-data-protection_en?prefLang=de", target: "_blank") { "https://commission.europa.eu/law/law-topic/data-protection/international-dimension-data-protection_en?prefLang=de." }
          end
        end

        div DataPrivacyNoticeColumn, DataPrivacyNoticeOriginal do
          h2 PrivacyRetentionDeletionId do
            "Allgemeine Informationen zur Datenspeicherung und Löschung"
          end
          p { "Wir löschen personenbezogene Daten, die wir verarbeiten, gemäß den gesetzlichen Bestimmungen, sobald die zugrundeliegenden Einwilligungen widerrufen werden oder keine weiteren rechtlichen Grundlagen für die Verarbeitung bestehen. Dies betrifft Fälle, in denen der ursprüngliche Verarbeitungszweck entfällt oder die Daten nicht mehr benötigt werden. Ausnahmen von dieser Regelung bestehen, wenn gesetzliche Pflichten oder besondere Interessen eine längere Aufbewahrung oder Archivierung der Daten erfordern." }
          p { "Insbesondere müssen Daten, die aus handels- oder steuerrechtlichen Gründen aufbewahrt werden müssen oder deren Speicherung notwendig ist zur Rechtsverfolgung oder zum Schutz der Rechte anderer natürlicher oder juristischer Personen, entsprechend archiviert werden." }
          p { "Unsere Datenschutzhinweise enthalten zusätzliche Informationen zur Aufbewahrung und Löschung von Daten, die speziell für bestimmte Verarbeitungsprozesse gelten." }
          p { "Bei mehreren Angaben zur Aufbewahrungsdauer oder Löschungsfristen eines Datums, ist stets die längste Frist maßgeblich. Daten, die nicht mehr für den ursprünglich vorgesehenen Zweck, sondern aufgrund gesetzlicher Vorgaben oder anderer Gründe aufbewahrt werden, verarbeiten wir ausschließlich zu den Gründen, die ihre Aufbewahrung rechtfertigen." }
          p { "Aufbewahrung und Löschung von Daten: Die folgenden allgemeinen Fristen gelten für die Aufbewahrung und Archivierung nach deutschem Recht:" }
          ul do
            li { "10 Jahre - Aufbewahrungsfrist für Bücher und Aufzeichnungen, Jahresabschlüsse, Inventare, Lageberichte, Eröffnungsbilanz sowie die zu ihrem Verständnis erforderlichen Arbeitsanweisungen und sonstigen Organisationsunterlagen (§ 147 Abs. 1 Nr. 1 i.V.m. Abs. 3 AO, § 14b Abs. 1 UStG, § 257 Abs. 1 Nr. 1 i.V.m. Abs. 4 HGB)." }
            li { "8 Jahre - Buchungsbelege, wie z. B. Rechnungen und Kostenbelege (§ 147 Abs. 1 Nr. 4 und 4a i.V.m. Abs. 3 Satz 1 AO sowie § 257 Abs. 1 Nr. 4 i.V.m. Abs. 4 HGB)." }
            li { "6 Jahre - Übrige Geschäftsunterlagen: empfangene Handels- oder Geschäftsbriefe, Wiedergaben der abgesandten Handels- oder Geschäftsbriefe, sonstige Unterlagen, soweit sie für die Besteuerung von Bedeutung sind, z. B. Stundenlohnzettel, Betriebsabrechnungsbögen, Kalkulationsunterlagen, Preisauszeichnungen, aber auch Lohnabrechnungsunterlagen, soweit sie nicht bereits Buchungsbelege sind und Kassenstreifen (§ 147 Abs. 1 Nr. 2, 3, 5 i.V.m. Abs. 3 AO, § 257 Abs. 1 Nr. 2 u. 3 i.V.m. Abs. 4 HGB)." }
            li { "3 Jahre - Daten, die erforderlich sind, um potenzielle Gewährleistungs- und Schadensersatzansprüche oder ähnliche vertragliche Ansprüche und Rechte zu berücksichtigen sowie damit verbundene Anfragen zu bearbeiten, basierend auf früheren Geschäftserfahrungen und üblichen Branchenpraktiken, werden für die Dauer der regulären gesetzlichen Verjährungsfrist von drei Jahren gespeichert (§§ 195, 199 BGB)." }
          end
          p { "Fristbeginn mit Ablauf des Jahres: Beginnt eine Frist nicht ausdrücklich zu einem bestimmten Datum und beträgt sie mindestens ein Jahr, so startet sie automatisch am Ende des Kalenderjahres, in dem das fristauslösende Ereignis eingetreten ist. Im Fall laufender Vertragsverhältnisse, in deren Rahmen Daten gespeichert werden, ist das fristauslösende Ereignis der Zeitpunkt des Wirksamwerdens der Kündigung oder sonstige Beendigung des Rechtsverhältnisses." }
        end

        div DataPrivacyNoticeColumn, DataPrivacyNoticeTranslation do
          h2 PrivacyEnglishRetentionDeletionId do
            "General Information on Data Retention and Deletion"
          end
          p { "We delete personal data that we process in accordance with the legal provisions as soon as the underlying consents are withdrawn or no further legal bases for the processing exist. This concerns cases in which the original processing purpose ceases to apply or the data is no longer needed. Exceptions to this rule exist if legal obligations or special interests require longer retention or archiving of the data." }
          p { "In particular, data that must be retained for reasons of commercial or tax law, or whose storage is necessary for legal prosecution or for the protection of the rights of other natural or legal persons, must be archived accordingly." }
          p { "Our privacy notices contain additional information on the retention and deletion of data that applies specifically to certain processing processes." }
          p { "In the case of multiple statements on the retention period or deletion periods of a datum, the longest period is always decisive. Data that is no longer retained for the originally intended purpose, but due to legal requirements or other reasons, is processed by us exclusively for the reasons that justify its retention." }
          p { "Retention and deletion of data: The following general periods apply to retention and archiving according to German law:" }
          ul do
            li { "10 years - retention period for books and records, annual financial statements, inventories, management reports, opening balance sheet, as well as the work instructions and other organizational documents necessary for their understanding (Sec. 147(1) no. 1 in conjunction with (3) German Fiscal Code (AO), Sec. 14b(1) German VAT Act (UStG), Sec. 257(1) no. 1 in conjunction with (4) German Commercial Code (HGB))." }
            li { "8 years - accounting vouchers, such as invoices and cost receipts (Sec. 147(1) nos. 4 and 4a in conjunction with (3) sentence 1 AO and Sec. 257(1) no. 4 in conjunction with (4) HGB)." }
            li { "6 years - remaining business documents: received commercial or business letters, reproductions of sent commercial or business letters, other documents insofar as they are relevant for taxation, such as hourly wage slips, operating accounting sheets, calculation documents, price labels, but also payroll documents insofar as they are not already accounting vouchers, and cash register tapes (Sec. 147(1) nos. 2, 3, 5 in conjunction with (3) AO, Sec. 257(1) nos. 2 and 3 in conjunction with (4) HGB)." }
            li { "3 years - data that is required in order to take potential warranty and damages claims or similar contractual claims and rights into account and to process related inquiries, based on previous business experience and usual industry practices, is stored for the duration of the regular statutory limitation period of three years (Secs. 195, 199 German Civil Code (BGB))." }
          end
          p { "Start of the period upon expiry of the year: If a period does not expressly begin on a specific date and is at least one year, it automatically starts at the end of the calendar year in which the event triggering the period occurred. In the case of ongoing contractual relationships in the context of which data is stored, the event triggering the period is the point in time at which the termination becomes effective or the legal relationship otherwise ends." }
        end

        div DataPrivacyNoticeColumn, DataPrivacyNoticeOriginal do
          h2 PrivacyDataSubjectRightsId do
            "Rechte der betroffenen Personen"
          end
          p { "Rechte der betroffenen Personen aus der DSGVO: Ihnen stehen als Betroffene nach der DSGVO verschiedene Rechte zu, die sich insbesondere aus Art. 15 bis 21 DSGVO ergeben:" }
          ul do
            li { strong { "Widerspruchsrecht: Sie haben das Recht, aus Gründen, die sich aus Ihrer besonderen Situation ergeben, jederzeit gegen die Verarbeitung der Sie betreffenden personenbezogenen Daten, die aufgrund von Art. 6 Abs. 1 lit. e oder f DSGVO erfolgt, Widerspruch einzulegen; dies gilt auch für ein auf diese Bestimmungen gestütztes Profiling. Werden die Sie betreffenden personenbezogenen Daten verarbeitet, um Direktwerbung zu betreiben, haben Sie das Recht, jederzeit Widerspruch gegen die Verarbeitung der Sie betreffenden personenbezogenen Daten zum Zwecke derartiger Werbung einzulegen; dies gilt auch für das Profiling, soweit es mit solcher Direktwerbung in Verbindung steht." } }
            li { strong { "Widerrufsrecht bei Einwilligungen:" }; span { " Sie haben das Recht, erteilte Einwilligungen jederzeit zu widerrufen." } }
            li { strong { "Auskunftsrecht:" }; span { " Sie haben das Recht, eine Bestätigung darüber zu verlangen, ob betreffende Daten verarbeitet werden und auf Auskunft über diese Daten sowie auf weitere Informationen und Kopie der Daten entsprechend den gesetzlichen Vorgaben." } }
            li { strong { "Recht auf Berichtigung:" }; span { " Sie haben entsprechend den gesetzlichen Vorgaben das Recht, die Vervollständigung der Sie betreffenden Daten oder die Berichtigung der Sie betreffenden unrichtigen Daten zu verlangen." } }
            li { strong { "Recht auf Löschung und Einschränkung der Verarbeitung:" }; span { " Sie haben nach Maßgabe der gesetzlichen Vorgaben das Recht, zu verlangen, dass Sie betreffende Daten unverzüglich gelöscht werden, bzw. alternativ nach Maßgabe der gesetzlichen Vorgaben eine Einschränkung der Verarbeitung der Daten zu verlangen." } }
            li { strong { "Recht auf Datenübertragbarkeit:" }; span { " Sie haben das Recht, Sie betreffende Daten, die Sie uns bereitgestellt haben, nach Maßgabe der gesetzlichen Vorgaben in einem strukturierten, gängigen und maschinenlesbaren Format zu erhalten oder deren Übermittlung an einen anderen Verantwortlichen zu fordern." } }
            li { strong { "Beschwerde bei Aufsichtsbehörde:" }; span { " Sie haben unbeschadet eines anderweitigen verwaltungsrechtlichen oder gerichtlichen Rechtsbehelfs das Recht auf Beschwerde bei einer Aufsichtsbehörde, insbesondere in dem Mitgliedstaat ihres gewöhnlichen Aufenthaltsorts, ihres Arbeitsplatzes oder des Orts des mutmaßlichen Verstoßes, wenn Sie der Ansicht sind, dass die Verarbeitung der Sie betreffenden personenbezogenen Daten gegen die Vorgaben der DSGVO verstößt." } }
          end
        end

        div DataPrivacyNoticeColumn, DataPrivacyNoticeTranslation do
          h2 PrivacyEnglishDataSubjectRightsId do
            "Rights of Data Subjects"
          end
          p { "Rights of data subjects under the GDPR: As a data subject, you are entitled to various rights under the GDPR, which arise in particular from Art. 15 to 21 GDPR:" }
          ul do
            li { strong { "Right to object: You have the right, on grounds relating to your particular situation, to object at any time to the processing of personal data concerning you that is carried out on the basis of Art. 6(1)(e) or (f) GDPR; this also applies to profiling based on those provisions. If personal data concerning you is processed for direct marketing purposes, you have the right to object at any time to the processing of personal data concerning you for the purpose of such marketing; this also applies to profiling insofar as it is related to such direct marketing." } }
            li { strong { "Right to withdraw consent:" }; span { " You have the right to withdraw consents given at any time." } }
            li { strong { "Right of access:" }; span { " You have the right to request confirmation as to whether data concerning you is being processed and to information about this data as well as to further information and a copy of the data in accordance with the legal requirements." } }
            li { strong { "Right to rectification:" }; span { " In accordance with the legal requirements, you have the right to request the completion of data concerning you or the correction of inaccurate data concerning you." } }
            li { strong { "Right to erasure and restriction of processing:" }; span { " In accordance with the legal requirements, you have the right to request that data concerning you be deleted without delay, or alternatively, in accordance with the legal requirements, to request a restriction of the processing of the data." } }
            li { strong { "Right to data portability:" }; span { " You have the right to receive data concerning you that you have provided to us, in accordance with the legal requirements, in a structured, commonly used, and machine-readable format or to request its transmission to another controller." } }
            li { strong { "Complaint with supervisory authority:" }; span { " Without prejudice to any other administrative-law or judicial remedy, you have the right to lodge a complaint with a supervisory authority, in particular in the member state of your habitual residence, your place of work, or the place of the alleged infringement, if you are of the opinion that the processing of personal data concerning you violates the requirements of the GDPR." } }
          end
        end

        div DataPrivacyNoticeColumn, DataPrivacyNoticeOriginal do
          h2 PrivacyWebhostingId do
            "Bereitstellung des Onlineangebots und Webhosting"
          end
          p { "Wir verarbeiten die Daten der Nutzer, um ihnen unsere Online-Dienste zur Verfügung stellen zu können. Zu diesem Zweck verarbeiten wir die IP-Adresse des Nutzers, die notwendig ist, um die Inhalte und Funktionen unserer Online-Dienste an den Browser oder das Endgerät der Nutzer zu übermitteln." }
          ul DataPrivacyNoticeMetaList do
            li do
              strong { "Verarbeitete Datenarten:" }
              span { " Nutzungsdaten (z. B. Seitenaufrufe und Verweildauer, Klickpfade, Nutzungsintensität und -frequenz, verwendete Gerätetypen und Betriebssysteme, Interaktionen mit Inhalten und Funktionen); Meta-, Kommunikations- und Verfahrensdaten (z. B. IP-Adressen, Zeitangaben, Identifikationsnummern, beteiligte Personen); Protokolldaten (z. B. Logfiles betreffend Logins oder den Abruf von Daten oder Zugriffszeiten.). Inhaltsdaten (z. B. textliche oder bildliche Nachrichten und Beiträge sowie die sie betreffenden Informationen, wie z. B. Angaben zur Autorenschaft oder Zeitpunkt der Erstellung)." }
            end
            li do
              strong { "Betroffene Personen:" }
              span { " Nutzer (z. B. Webseitenbesucher, Nutzer von Onlinediensten)." }
            end
            li do
              strong { "Zwecke der Verarbeitung und berechtigte Interessen:" }
              span { " Bereitstellung unseres Onlineangebotes und Nutzerfreundlichkeit; Informationstechnische Infrastruktur (Betrieb und Bereitstellung von Informationssystemen und technischen Geräten (Computer, Server etc.)); Sicherheitsmaßnahmen. Servermonitoring und Fehlererkennung." }
            end
            li do
              strong { "Aufbewahrung und Löschung:" }
              span { " Löschung entsprechend Angaben im Abschnitt \"Allgemeine Informationen zur Datenspeicherung und Löschung\"." }
            end
            li do
              strong { "Rechtsgrundlagen:" }
              span { " Berechtigte Interessen (Art. 6 Abs. 1 S. 1 lit. f) DSGVO)." }
            end
          end
          p { strong { "Weitere Hinweise zu Verarbeitungsprozessen, Verfahren und Diensten:" } }
          ul DataPrivacyNoticeMetaList do
            li { strong { "Bereitstellung Onlineangebot auf gemietetem Speicherplatz: " }; span { "Für die Bereitstellung unseres Onlineangebotes nutzen wir Speicherplatz, Rechenkapazität und Software, die wir von einem entsprechenden Serveranbieter (auch \"Webhoster\" genannt) mieten oder anderweitig beziehen; " }; strong { "Rechtsgrundlagen:" }; span { " Berechtigte Interessen (Art. 6 Abs. 1 S. 1 lit. f) DSGVO)." } }
            li { strong { "Erhebung von Zugriffsdaten und Logfiles: " }; span { "Der Zugriff auf unser Onlineangebot wird in Form von sogenannten \"Server-Logfiles\" protokolliert. Zu den Serverlogfiles können die Adresse und der Name der abgerufenen Webseiten und Dateien, Datum und Uhrzeit des Abrufs, übertragene Datenmengen, Meldung über erfolgreichen Abruf, Browsertyp nebst Version, das Betriebssystem des Nutzers, Referrer URL (die zuvor besuchte Seite) und im Regelfall IP-Adressen und der anfragende Provider gehören. Die Serverlogfiles können zum einen zu Sicherheitszwecken eingesetzt werden, z. B. um eine Überlastung der Server zu vermeiden (insbesondere im Fall von missbräuchlichen Angriffen, sogenannten DDoS-Attacken), und zum anderen, um die Auslastung der Server und ihre Stabilität sicherzustellen; " }; strong { "Rechtsgrundlagen:" }; span { " Berechtigte Interessen (Art. 6 Abs. 1 S. 1 lit. f) DSGVO). " }; strong { "Löschung von Daten:" }; span { " Logfile-Informationen werden für die Dauer von maximal 30 Tagen gespeichert und danach gelöscht oder anonymisiert. Daten, deren weitere Aufbewahrung zu Beweiszwecken erforderlich ist, sind bis zur endgültigen Klärung des jeweiligen Vorfalls von der Löschung ausgenommen." } }
            li { strong { "New Relic: " }; span { "Servermonitoring und Fehlererkennung; " }; strong { "Dienstanbieter:" }; span { " New Relic, Inc. Attn: Legal Department 188 Spear Street, Suite 1200 San Francisco, CA 94105, USA; " }; strong { "Rechtsgrundlagen:" }; span { " Berechtigte Interessen (Art. 6 Abs. 1 S. 1 lit. f) DSGVO); " }; strong { "Website:" }; span { " " }; a(href: "https://newrelic.com", target: "_blank") { "https://newrelic.com" }; span { "; " }; strong { "Sicherheitsmaßnahmen:" }; span { " IP-Masking (Pseudonymisierung der IP-Adresse); " }; strong { "Datenschutzerklärung:" }; span { " " }; a(href: "https://newrelic.com/termsandconditions/privacy", target: "_blank") { "https://newrelic.com/termsandconditions/privacy" }; span { "; " }; strong { "Auftragsverarbeitungsvertrag:" }; span { " " }; a(href: "https://newrelic.com/termsandconditions/terms", target: "_blank") { "https://newrelic.com/termsandconditions/terms" }; span { "; " }; strong { "Grundlage Drittlandtransfers:" }; span { " Data Privacy Framework (DPF), Standardvertragsklauseln (Wird vom Dienstanbieter bereitgestellt). " }; strong { "Löschung von Daten:" }; span { " Die aggregierten Daten werden nach drei Monaten gelöscht, die pseudonymisierten Daten nach sieben Tagen." } }
          end
        end

        div DataPrivacyNoticeColumn, DataPrivacyNoticeTranslation do
          h2 PrivacyEnglishWebhostingId do
            "Provision of the Online Offering and Web Hosting"
          end
          p { "We process the users' data in order to be able to provide them with our online services. For this purpose, we process the user's IP address, which is necessary in order to transmit the contents and functions of our online services to the browser or end device of the users." }
          ul DataPrivacyNoticeMetaList do
            li do
              strong { "Types of data processed:" }
              span { " Usage data (e.g. page views and length of stay, click paths, intensity and frequency of use, device types and operating systems used, interactions with content and functions); meta, communication, and procedural data (e.g. IP addresses, time information, identification numbers, persons involved); log data (e.g. log files concerning logins or the retrieval of data or access times.). Content data (e.g. textual or visual messages and posts as well as information concerning them, such as details on authorship or time of creation)." }
            end
            li do
              strong { "Data subjects:" }
              span { " Users, such as website visitors and users of online services." }
            end
            li do
              strong { "Purposes and legitimate interests:" }
              span { " Provision of our online offering and user-friendliness; information technology infrastructure (operation and provision of information systems and technical devices (computers, servers, etc.)); security measures. Server monitoring and error detection." }
            end
            li do
              strong { "Retention and deletion:" }
              span { " Deletion in accordance with the information in the section \"General Information on Data Retention and Deletion\"." }
            end
            li do
              strong { "Legal bases:" }
              span { " Legitimate interests (Art. 6(1)(f) GDPR)." }
            end
          end
          p { strong { "Further information on processing operations, procedures, and services:" } }
          ul DataPrivacyNoticeMetaList do
            li { strong { "Provision of online offering on rented storage space: " }; span { "For the provision of our online offering, we use storage space, computing capacity, and software that we rent or otherwise obtain from a corresponding server provider (also called a \"web host\"); " }; strong { "Legal bases:" }; span { " Legitimate interests (Art. 6(1)(f) GDPR)." } }
            li { strong { "Collection of access data and log files: " }; span { "Access to our online offering is logged in the form of so-called \"server log files\". The server log files may include the address and name of the retrieved web pages and files, date and time of retrieval, transferred data volumes, notification of successful retrieval, browser type together with version, the user's operating system, referrer URL (the previously visited page), and, as a rule, IP addresses and the requesting provider. The server log files may be used, on the one hand, for security purposes, e.g. to avoid overloading the servers (in particular in the case of abusive attacks, so-called DDoS attacks), and, on the other hand, to ensure the utilization of the servers and their stability; " }; strong { "Legal bases:" }; span { " Legitimate interests (Art. 6(1)(f) GDPR). " }; strong { "Deletion of data:" }; span { " Log file information is stored for a maximum duration of 30 days and then deleted or anonymized. Data whose further retention is required for evidence purposes is exempt from deletion until the respective incident has been finally clarified." } }
            li { strong { "New Relic: " }; span { "Server monitoring and error detection; " }; strong { "Service provider:" }; span { " New Relic, Inc. Attn: Legal Department 188 Spear Street, Suite 1200 San Francisco, CA 94105, USA; " }; strong { "Legal bases:" }; span { " Legitimate interests (Art. 6(1)(f) GDPR); " }; strong { "Website:" }; span { " " }; a(href: "https://newrelic.com", target: "_blank") { "https://newrelic.com" }; span { "; " }; strong { "Security measures:" }; span { " IP masking (pseudonymization of the IP address); " }; strong { "Privacy policy:" }; span { " " }; a(href: "https://newrelic.com/termsandconditions/privacy", target: "_blank") { "https://newrelic.com/termsandconditions/privacy" }; span { "; " }; strong { "Data processing agreement:" }; span { " " }; a(href: "https://newrelic.com/termsandconditions/terms", target: "_blank") { "https://newrelic.com/termsandconditions/terms" }; span { "; " }; strong { "Basis for third-country transfers:" }; span { " Data Privacy Framework (DPF), standard contractual clauses (provided by the service provider). " }; strong { "Deletion of data:" }; span { " Aggregated data is deleted after three months, and pseudonymized data after seven days." } }
          end
        end

        div DataPrivacyNoticeColumn, DataPrivacyNoticeOriginal do
          h2 PrivacyCookiesId do
            "Einsatz von Cookies"
          end
          p { "Unter dem Begriff \"Cookies\" werden Funktionen, die Informationen auf Endgeräten der Nutzer speichern und aus ihnen auslesen, verstanden. Cookies können ferner in Bezug auf unterschiedliche Anliegen Einsatz finden, etwa zu Zwecken der Funktionsfähigkeit, der Sicherheit und des Komforts von Onlineangeboten sowie der Erstellung von Analysen der Besucherströme. Wir verwenden Cookies gemäß den gesetzlichen Vorschriften. Dazu holen wir, wenn erforderlich, vorab die Zustimmung der Nutzer ein. Ist eine Zustimmung nicht notwendig, setzen wir auf unsere berechtigten Interessen. Dies gilt, wenn das Speichern und Auslesen von Informationen unerlässlich ist, um ausdrücklich angeforderte Inhalte und Funktionen bereitstellen zu können. Dazu zählen etwa die Speicherung von Einstellungen sowie die Sicherstellung der Funktionalität und Sicherheit unseres Onlineangebots. Die Einwilligung kann jederzeit widerrufen werden. Wir informieren klar über deren Umfang und welche Cookies genutzt werden." }
          p { strong { "Hinweise zu datenschutzrechtlichen Rechtsgrundlagen: " }; span { "Ob wir personenbezogene Daten mithilfe von Cookies verarbeiten, hängt von einer Einwilligung ab. Liegt eine Einwilligung vor, dient sie als Rechtsgrundlage. Ohne Einwilligung stützen wir uns auf unsere berechtigten Interessen, die vorstehend in diesem Abschnitt und im Kontext der jeweiligen Dienste und Verfahren erläutert sind." } }
          p { strong { "Speicherdauer: " }; span { "Im Hinblick auf die Speicherdauer werden die folgenden Arten von Cookies unterschieden:" } }
          ul do
            li { strong { "Temporäre Cookies (auch: Session- oder Sitzungscookies):" }; span { " Temporäre Cookies werden spätestens gelöscht, nachdem ein Nutzer ein Onlineangebot verlassen und sein Endgerät (z. B. Browser oder mobile Applikation) geschlossen hat." } }
            li { strong { "Permanente Cookies:" }; span { " Permanente Cookies bleiben auch nach dem Schließen des Endgeräts gespeichert. So können beispielsweise der Log-in-Status gespeichert und bevorzugte Inhalte direkt angezeigt werden, wenn der Nutzer eine Website erneut besucht. Ebenso können die mithilfe von Cookies erhobenen Nutzerdaten zur Reichweitenmessung Verwendung finden. Sofern wir Nutzern keine expliziten Angaben zur Art und Speicherdauer von Cookies mitteilen (z. B. im Rahmen der Einholung der Einwilligung), sollten sie davon ausgehen, dass diese permanent sind und die Speicherdauer bis zu zwei Jahre betragen kann." } }
          end
          p { strong { "Allgemeine Hinweise zum Widerruf und Widerspruch (Opt-out): " }; span { "Nutzer können die von ihnen abgegebenen Einwilligungen jederzeit widerrufen und zudem einen Widerspruch gegen die Verarbeitung entsprechend den gesetzlichen Vorgaben, auch mittels der Privatsphäre-Einstellungen ihres Browsers, erklären." } }
          ul DataPrivacyNoticeMetaList do
            li do
              strong { "Verarbeitete Datenarten:" }
              span { " Meta-, Kommunikations- und Verfahrensdaten (z. B. IP-Adressen, Zeitangaben, Identifikationsnummern, beteiligte Personen)." }
            end
            li do
              strong { "Betroffene Personen:" }
              span { " Nutzer (z. B. Webseitenbesucher, Nutzer von Onlinediensten)." }
            end
            li do
              strong { "Rechtsgrundlagen:" }
              span { " Berechtigte Interessen (Art. 6 Abs. 1 S. 1 lit. f) DSGVO). Einwilligung (Art. 6 Abs. 1 S. 1 lit. a) DSGVO)." }
            end
          end
          p { strong { "Weitere Hinweise zu Verarbeitungsprozessen, Verfahren und Diensten:" } }
          ul DataPrivacyNoticeMetaList do
            li { strong { "Verarbeitung von Cookie-Daten auf Grundlage einer Einwilligung: " }; span { "Wir setzen eine Einwilligungs-Management-Lösung ein, bei der die Einwilligung der Nutzer zur Verwendung von Cookies oder zu den im Rahmen der Einwilligungs-Management-Lösung genannten Verfahren und Anbietern eingeholt wird. Die Einwilligungserklärungen werden gespeichert, um eine erneute Abfrage zu vermeiden und den Nachweis der Einwilligung gemäß der gesetzlichen Anforderungen führen zu können; " }; strong { "Rechtsgrundlagen:" }; span { " Einwilligung (Art. 6 Abs. 1 S. 1 lit. a) DSGVO)." } }
          end
        end

        div DataPrivacyNoticeColumn, DataPrivacyNoticeTranslation do
          h2 PrivacyEnglishCookiesId do
            "Use of Cookies"
          end
          p { "The term \"cookies\" is understood to mean functions that store information on users' end devices and read information from them. Cookies may further be used in relation to different concerns, for example for purposes of the functionality, security, and convenience of online offerings as well as the creation of analyses of visitor flows. We use cookies in accordance with the statutory provisions. For this, where required, we obtain the users' consent in advance. If consent is not necessary, we rely on our legitimate interests. This applies if the storing and reading of information is indispensable in order to be able to provide expressly requested content and functions. This includes, for example, the storage of settings as well as ensuring the functionality and security of our online offering. Consent can be withdrawn at any time. We clearly inform about its scope and which cookies are used." }
          p { strong { "Notes on data protection legal bases: " }; span { "Whether we process personal data with the help of cookies depends on consent. If consent exists, it serves as the legal basis. Without consent, we rely on our legitimate interests, which are explained above in this section and in the context of the respective services and procedures." } }
          p { strong { "Storage period: " }; span { "With regard to the storage period, the following types of cookies are distinguished:" } }
          ul do
            li { strong { "Temporary cookies (also: session cookies):" }; span { " Temporary cookies are deleted at the latest after a user has left an online offering and closed their end device (e.g. browser or mobile application)." } }
            li { strong { "Permanent cookies:" }; span { " Permanent cookies remain stored even after the end device is closed. For example, the login status can be stored and preferred content can be displayed directly when the user visits a website again. Likewise, the usage data collected with the help of cookies may be used for reach measurement. If we do not provide users with explicit information on the type and storage duration of cookies (e.g. in the context of obtaining consent), they should assume that these are permanent and that the storage duration may be up to two years." } }
          end
          p { strong { "General notes on withdrawal and objection (opt-out): " }; span { "Users may withdraw the consents they have given at any time and furthermore declare an objection to processing in accordance with the legal requirements, also by means of the privacy settings of their browser." } }
          ul DataPrivacyNoticeMetaList do
            li do
              strong { "Types of data processed:" }
              span { " Meta, communication, and procedural data (e.g. IP addresses, time information, identification numbers, persons involved)." }
            end
            li do
              strong { "Data subjects:" }
              span { " Users, such as website visitors and users of online services." }
            end
            li do
              strong { "Legal bases:" }
              span { " Legitimate interests (Art. 6(1)(f) GDPR). Consent (Art. 6(1)(a) GDPR)." }
            end
          end
          p { strong { "Further information on processing operations, procedures, and services:" } }
          ul DataPrivacyNoticeMetaList do
            li { strong { "Processing of cookie data on the basis of consent: " }; span { "We use a consent management solution in which the consent of users to the use of cookies or to the procedures and providers named within the scope of the consent management solution is obtained. The declarations of consent are stored in order to avoid a renewed query and to be able to provide proof of consent in accordance with the legal requirements; " }; strong { "Legal bases:" }; span { " Consent (Art. 6(1)(a) GDPR)." } }
          end
        end

        div DataPrivacyNoticeColumn, DataPrivacyNoticeOriginal do
          h2 PrivacyUserAccountId do
            "Registrierung, Anmeldung und Nutzerkonto"
          end
          p { "Nutzer können ein Nutzerkonto anlegen. Im Rahmen der Registrierung werden den Nutzern die erforderlichen Pflichtangaben mitgeteilt und zu Zwecken der Bereitstellung des Nutzerkontos verarbeitet. Zu den verarbeiteten Daten gehören insbesondere die Login-Informationen (Nutzername, Passwort sowie eine E-Mail-Adresse)." }
          p { "Im Rahmen der Nutzung unserer Registrierungs- und Anmeldefunktionen sowie des Nutzerkontos speichern wir die IP-Adresse und den Zeitpunkt der jeweiligen Nutzerhandlung. Die Speicherung erfolgt auf Grundlage unserer berechtigten Interessen sowie jener der Nutzer an einem Schutz vor Missbrauch und sonstiger unbefugter Nutzung." }
          p { "Die Nutzer können über Vorgänge, die für deren Nutzerkonto relevant sind, wie z. B. technische Änderungen, per E-Mail informiert werden." }
          ul DataPrivacyNoticeMetaList do
            li do
              strong { "Verarbeitete Datenarten:" }
              span { " Bestandsdaten; Kontaktdaten; Inhaltsdaten; Nutzungsdaten; Protokolldaten." }
            end
            li do
              strong { "Betroffene Personen:" }
              span { " Nutzer (z. B. Webseitenbesucher, Nutzer von Onlinediensten)." }
            end
            li do
              strong { "Rechtsgrundlagen:" }
              span { " Vertragserfüllung und vorvertragliche Anfragen (Art. 6 Abs. 1 S. 1 lit. b) DSGVO). Berechtigte Interessen (Art. 6 Abs. 1 S. 1 lit. f) DSGVO)." }
            end
            li do
              strong { "Profile der Nutzer sind nicht öffentlich:" }
              span { " Die Profile der Nutzer sind öffentlich nicht sichtbar und nicht zugänglich." }
            end
          end
        end

        div DataPrivacyNoticeColumn, DataPrivacyNoticeTranslation do
          h2 PrivacyEnglishUserAccountId do
            "Registration, Login, and User Account"
          end
          p { "Users can create a user account. In the context of registration, the required mandatory information is communicated to the users and processed for purposes of providing the user account. The processed data includes, in particular, the login information (username, password, and an email address)." }
          p { "In the context of the use of our registration and login functions as well as the user account, we store the IP address and the time of the respective user action. The storage takes place on the basis of our legitimate interests as well as those of the users in protection against misuse and other unauthorized use." }
          p { "The users can be informed by email about processes that are relevant to their user account, such as technical changes." }
          ul DataPrivacyNoticeMetaList do
            li do
              strong { "Types of data processed:" }
              span { " Inventory data; contact data; content data; usage data; log data." }
            end
            li do
              strong { "Data subjects:" }
              span { " Users, such as website visitors and users of online services." }
            end
            li do
              strong { "Legal bases:" }
              span { " Performance of a contract and pre-contractual requests (Art. 6(1)(b) GDPR). Legitimate interests (Art. 6(1)(f) GDPR)." }
            end
            li do
              strong { "Profiles of users are not public:" }
              span { " The profiles of users are not publicly visible and not accessible." }
            end
          end
        end

        div DataPrivacyNoticeColumn, DataPrivacyNoticeOriginal do
          h2 PrivacyContactRequestsId do
            "Kontakt- und Anfrageverwaltung"
          end
          p { "Bei der Kontaktaufnahme mit uns (z. B. per Post, Kontaktformular, E-Mail, Telefon oder via soziale Medien) sowie im Rahmen bestehender Nutzer- und Geschäftsbeziehungen werden die Angaben der anfragenden Personen verarbeitet, soweit dies zur Beantwortung der Kontaktanfragen und etwaiger angefragter Maßnahmen erforderlich ist." }
          ul DataPrivacyNoticeMetaList do
            li do
              strong { "Verarbeitete Datenarten:" }
              span { " Kontaktdaten; Inhaltsdaten; Meta-, Kommunikations- und Verfahrensdaten." }
            end
            li do
              strong { "Betroffene Personen:" }
              span { " Kommunikationspartner." }
            end
            li do
              strong { "Rechtsgrundlagen:" }
              span { " Berechtigte Interessen (Art. 6 Abs. 1 S. 1 lit. f) DSGVO). Vertragserfüllung und vorvertragliche Anfragen (Art. 6 Abs. 1 S. 1 lit. b) DSGVO)." }
            end
          end
        end

        div DataPrivacyNoticeColumn, DataPrivacyNoticeTranslation do
          h2 PrivacyEnglishContactRequestsId do
            "Contact and Request Management"
          end
          p { "When contacting us (e.g. by post, contact form, email, telephone, or via social media) as well as in the context of existing user and business relationships, the information of the requesting persons is processed insofar as this is necessary to answer the contact requests and any requested measures." }
          ul DataPrivacyNoticeMetaList do
            li do
              strong { "Types of data processed:" }
              span { " Contact data; content data; meta, communication, and procedural data." }
            end
            li do
              strong { "Data subjects:" }
              span { " Communication partners." }
            end
            li do
              strong { "Legal bases:" }
              span { " Legitimate interests (Art. 6(1)(f) GDPR). Performance of a contract and pre-contractual requests (Art. 6(1)(b) GDPR)." }
            end
          end
        end

        div DataPrivacyNoticeColumn, DataPrivacyNoticeOriginal do
          h2 PrivacyEmbeddedContentId do
            "Plug-ins und eingebettete Funktionen sowie Inhalte"
          end
          p { "Wir binden Funktions- und Inhaltselemente in unser Onlineangebot ein, die von den Servern ihrer jeweiligen Anbieter bezogen werden. Dabei kann es sich zum Beispiel um Grafiken, Videos oder Stadtpläne handeln." }
          p { "Die Einbindung setzt regelmäßig voraus, dass die Drittanbieter dieser Inhalte die IP-Adresse der Nutzer verarbeiten, da sie ohne IP-Adresse die Inhalte nicht an deren Browser senden könnten." }
          ul DataPrivacyNoticeMetaList do
            li do
              strong { "Google Fonts (Bereitstellung auf eigenem Server):" }
              span { " Bereitstellung von Schriftarten-Dateien zwecks einer nutzerfreundlichen Darstellung unseres Onlineangebotes; die Google Fonts werden auf unserem Server gehostet, es werden keine Daten an Google übermittelt." }
            end
          end
        end

        div DataPrivacyNoticeColumn, DataPrivacyNoticeTranslation do
          h2 PrivacyEnglishEmbeddedContentId do
            "Plug-ins, Embedded Functions, and Content"
          end
          p { "We integrate functional and content elements into our online offering that are obtained from the servers of their respective providers. These may be, for example, graphics, videos, or city maps." }
          p { "The integration regularly requires the third-party providers of this content to process users' IP addresses, because without the IP address they could not send the content to the users' browser." }
          ul DataPrivacyNoticeMetaList do
            li do
              strong { "Google Fonts (provided on our own server):" }
              span { " Provision of font files for the purpose of a user-friendly display of our online offering; the Google Fonts are hosted on our server, no data is transmitted to Google." }
            end
          end
        end

        div DataPrivacyNoticeColumn, DataPrivacyNoticeOriginal do
          h2 PrivacyChangesId do
            "Änderung und Aktualisierung"
          end
          p { "Wir bitten Sie, sich regelmäßig über den Inhalt unserer Datenschutzerklärung zu informieren. Wir passen die Datenschutzerklärung an, sobald die Änderungen der von uns durchgeführten Datenverarbeitungen dies erforderlich machen." }
          p { "Sofern wir in dieser Datenschutzerklärung Adressen und Kontaktinformationen von Unternehmen und Organisationen angeben, bitten wir zu beachten, dass die Adressen sich über die Zeit ändern können und bitten die Angaben vor Kontaktaufnahme zu prüfen." }
        end

        div DataPrivacyNoticeColumn, DataPrivacyNoticeTranslation do
          h2 PrivacyEnglishChangesId do
            "Changes and Updates"
          end
          p { "We ask you to inform yourself regularly about the content of our privacy policy. We adapt the privacy policy as soon as changes to the data processing carried out by us make this necessary." }
          p { "Insofar as we provide addresses and contact information of companies and organizations in this privacy policy, we ask you to note that the addresses may change over time and ask you to check the information before contacting them." }
        end

        div DataPrivacyNoticeColumn, DataPrivacyNoticeOriginal do
          h2 PrivacyDefinitionsId do
            "Begriffsdefinitionen"
          end
          p { "In diesem Abschnitt erhalten Sie eine Übersicht über die in dieser Datenschutzerklärung verwendeten Begrifflichkeiten. Soweit die Begrifflichkeiten gesetzlich definiert sind, gelten deren gesetzliche Definitionen." }
          ul DataPrivacyNoticeMetaList do
            li do
              strong { "Beschäftigte:" }
              span { " Personen in einem Beschäftigungsverhältnis und Daten, die sich auf diese Personen im Kontext ihrer Beschäftigung beziehen." }
            end
            li do
              strong { "Bestandsdaten:" }
              span { " Wesentliche Informationen, die für die Identifikation und Verwaltung von Vertragspartnern, Benutzerkonten, Profilen und ähnlichen Zuordnungen notwendig sind." }
            end
            li do
              strong { "Inhaltsdaten:" }
              span { " Informationen, die im Zuge der Erstellung, Bearbeitung und Veröffentlichung von Inhalten aller Art generiert werden." }
            end
            li do
              strong { "Kontaktdaten:" }
              span { " Informationen, die die Kommunikation mit Personen oder Organisationen ermöglichen." }
            end
            li do
              strong { "Nutzungsdaten:" }
              span { " Informationen darüber, wie Nutzer mit digitalen Produkten, Dienstleistungen oder Plattformen interagieren." }
            end
            li do
              strong { "Personenbezogene Daten:" }
              span { " Alle Informationen, die sich auf eine identifizierte oder identifizierbare natürliche Person beziehen." }
            end
            li do
              strong { "Verantwortlicher:" }
              span { " Die natürliche oder juristische Person, die über die Zwecke und Mittel der Verarbeitung von personenbezogenen Daten entscheidet." }
            end
            li do
              strong { "Verarbeitung:" }
              span { " Jeder Vorgang im Zusammenhang mit personenbezogenen Daten, etwa Erheben, Speichern, Übermitteln oder Löschen." }
            end
          end
          p DataPrivacyNoticeSeal do
            a(href: "https://datenschutz-generator.de/", title: "Rechtstext von Dr. Schwenke - für weitere Informationen bitte anklicken.", target: "_blank", rel: "noopener noreferrer nofollow") { "Erstellt mit kostenlosem Datenschutz-Generator.de von Dr. Thomas Schwenke" }
          end
        end

        div DataPrivacyNoticeColumn, DataPrivacyNoticeTranslation do
          h2 PrivacyEnglishDefinitionsId do
            "Definitions"
          end
          p { "In this section, you receive an overview of the terminology used in this privacy policy. Insofar as the terms are legally defined, their legal definitions apply." }
          ul DataPrivacyNoticeMetaList do
            li do
              strong { "Employees:" }
              span { " Persons in an employment relationship and data that relates to these persons in the context of their employment." }
            end
            li do
              strong { "Inventory data:" }
              span { " Essential information that is necessary for the identification and management of contractual partners, user accounts, profiles, and similar assignments." }
            end
            li do
              strong { "Content data:" }
              span { " Information that is generated in the course of creating, editing, and publishing content of all kinds." }
            end
            li do
              strong { "Contact data:" }
              span { " Information that enables communication with persons or organizations." }
            end
            li do
              strong { "Usage data:" }
              span { " Information about how users interact with digital products, services, or platforms." }
            end
            li do
              strong { "Personal data:" }
              span { " All information relating to an identified or identifiable natural person." }
            end
            li do
              strong { "Controller:" }
              span { " The natural or legal person who decides on the purposes and means of the processing of personal data." }
            end
            li do
              strong { "Processing:" }
              span { " Any operation in connection with personal data, such as collection, storage, transmission, or deletion." }
            end
          end
          p DataPrivacyNoticeSeal do
            span { "The German privacy policy was created with the " }
            a(href: "https://datenschutz-generator.de/", title: "Legal text by Dr. Schwenke - click for further information.", target: "_blank", rel: "noopener noreferrer nofollow") { "free Datenschutz-Generator.de by Dr. Thomas Schwenke" }
            span { ". This English version is a translation of the German version." }
          end
        end
      end
    end
  end

  ToHtml.inline_template :controller_address do |email_label|
    p do
      span { legal_name }
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
      span { "#{email_label}: " }
      a(href: "mailto:#{legal_email}") { legal_email }
    end
  end

  private def legal_name : String
    ENV.fetch("LEGAL_NOTICE_NAME")
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

  private def legal_email : String
    ENV.fetch("LEGAL_NOTICE_EMAIL")
  end

  def window_title : String?
    "Privacy policy"
  end
end
