module Crumble
  module Server
    class SessionDecorator
      def user
        return unless user_id = self.user_id

        User.where({"id" => user_id}).first?
      end

      # Ensures the session has a persisted user and returns it.
      # Creates a new user and stores its id in the session if missing.
      def ensure_user : User
        if user = self.user
          user
        else
          new_user = User.create
          update!(user_id: new_user.id.value)
          new_user
        end
      end
    end
  end
end
