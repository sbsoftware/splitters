class HomeResource < Crumble::Resource
  def self.root_path
    "/"
  end

  def index
    render HomeView
  end
end
