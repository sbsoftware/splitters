require "./service_worker"

class ServiceWorkerRegistration < JS::Code
  def_to_js do
    if navigator.serviceWorker
      navigator.serviceWorker.register(ServiceWorker.uri_path.to_js_ref).then do |registration|
        console.debug("Service worker registered")
      end
    else
      console.debug("Service workers not supported")
    end
  end
end
