module Crumble
  module Server
    class SessionDecorator
      def user
        return unless user_id = self.user_id

        User.find(user_id)
      end
    end
  end
end
