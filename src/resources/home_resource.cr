class HomeResource < ApplicationResource
  def self.root_path
    "/"
  end

  def index
    render HomeView
  end
end
