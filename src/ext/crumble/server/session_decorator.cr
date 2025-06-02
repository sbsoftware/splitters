module Crumble
  module Server
    class SessionDecorator
      def user
        return unless user_id = self.user_id

        User.where({"id" => user_id}).first?
      end
    end
  end
end
