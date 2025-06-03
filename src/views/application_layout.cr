class ApplicationLayout < Crumble::Material::Layout
  append_to_head ApplicationStyle
  append_to_head ServiceWorkerRegistration

  def headline
    "Splitters"
  end
end
