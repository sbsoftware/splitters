require "spec"

describe "LICENSE" do
  it "excludes third-party legal notices from the MIT license" do
    license = File.read("#{__DIR__}/../LICENSE")

    license.includes?("src/pages/legal_notice_page.cr").should be_true
    license.includes?("src/pages/privacy_notice_page.cr").should be_true
    license.includes?("not licensed under this MIT License").should be_true
    license.includes?("excluded pages or their contents").should be_true
  end
end
