class ApplicationLayout < Crumble::Material::Layout
  append_to_head ServiceWorkerRegistration

  def window_title
    "splitters.money"
  end

  def headline
    "Splitters"
  end
end
