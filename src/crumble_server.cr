require "./environment"

# Empty service worker for now
register_service_worker do
  cacheName = "splittersApp"
  cachedResources = [] of String
  cachedResources.push(Crumble::Material::RobotoRegular.uri_path.to_js_ref)
  cachedResources.push(Crumble::Material::Icon::Font.uri_path.to_js_ref)

  self.addEventListener("install") do |event|
    event.waitUntil(
      caches.open(cacheName).then do |cache|
        return cache.addAll(cachedResources)
      end
    )
  end

  self.addEventListener("fetch") do |event|
    if cachedResources.includes(URL.new(event.request.url).pathname)
      event.respondWith(
        caches.match(event.request).then do |cachedResponse|
          if cachedResponse
            return cachedResponse
          else
            fetch(event.request).then do |response|
              return response
            end
          end
        end
      )
    end
  end
end

web_manifest do
  name "splitters.money"
  short_name "Splitters"
  description "Collaborative expense splitting app"
  display :standalone
  background_color "white"
  theme_color "black"

  icon PNGFile.register("logo-192.png", "assets/logo-192.png"), sizes: "192x192"
  icon PNGFile.register("logo-512.png", "assets/logo-512.png"), sizes: "512x512"
end

Crumble::Server.start
