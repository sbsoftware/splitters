require "../spec_helper"
require "crumble/spec/test_request_context"

module LegalNoticePageSpec
  def self.set_legal_notice_env(name2)
    ENV["LEGAL_NOTICE_NAME"] = "First Legal Row"
    ENV["LEGAL_NOTICE_NAME2"] = name2
    ENV["LEGAL_NOTICE_STREET"] = "Example Street 1"
    ENV["LEGAL_NOTICE_CITY"] = "12345 Example City"
    ENV["LEGAL_NOTICE_COUNTRY"] = "Example Country"
    ENV["LEGAL_NOTICE_REPRESENTED_BY"] = "Example Representative"
    ENV["LEGAL_NOTICE_PHONE"] = "+49 123 456789"
    ENV["LEGAL_NOTICE_FAX"] = ""
    ENV["LEGAL_NOTICE_EMAIL"] = "legal@example.test"
  end

  def self.render_page(page)
    response_io = IO::Memory.new
    ctx = Crumble::Server::TestRequestContext.new(
      resource: page.uri_path,
      method: "GET",
      response_io: response_io
    )

    page.handle(ctx).should be_true
    ctx.response.status_code.should eq(200)
    ctx.response.close

    response_io.rewind
    response_io.to_s
  end

  describe LegalNoticePage do
    it "renders a second legal notice name row when configured" do
      LegalNoticePageSpec.set_legal_notice_env("Second Legal Row")

      html = LegalNoticePageSpec.render_page(LegalNoticePage)

      html.includes?("First Legal Row").should be_true
      html.includes?("Second Legal Row").should be_true
      html.includes?("Example Street 1").should be_true
    end

    it "omits the second legal notice name row when it is empty" do
      LegalNoticePageSpec.set_legal_notice_env("")

      html = LegalNoticePageSpec.render_page(LegalNoticePage)

      html.includes?("First Legal Row").should be_true
      html.includes?("Second Legal Row").should be_false
      html.includes?("Example Street 1").should be_true
    end
  end

  describe PrivacyNoticePage do
    it "renders a second legal notice name row in controller addresses when configured" do
      LegalNoticePageSpec.set_legal_notice_env("Second Legal Row")

      html = LegalNoticePageSpec.render_page(PrivacyNoticePage)

      html.includes?("First Legal Row").should be_true
      html.includes?("Second Legal Row").should be_true
      html.includes?("Example Street 1").should be_true
    end
  end
end
