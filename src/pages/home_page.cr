class HomePage < ApplicationPage
  def self.root_path
    "/"
  end

  def self.uri_path_matcher
    /^\/$/
  end

  view HomeView
end
