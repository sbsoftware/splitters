class ServiceWorker < JS::Code
  File = JavascriptFile.new("/service_worker.js", self.to_js)

  def self.uri_path
    File.uri_path
  end

  def_to_js do
    cacheName = "einkaufslisteApp"
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
end
