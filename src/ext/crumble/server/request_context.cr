module Crumble
  module Server
    class RequestContext
      def self.init_session_store
        FileSessionStore.new("./tmp/sessions")
      end

      def session_cookie_max_age
        3650.days
      end
    end
  end
end
