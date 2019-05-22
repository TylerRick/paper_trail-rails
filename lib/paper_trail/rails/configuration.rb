module PaperTrail
  module Rails
    class Configuration
      def initialize
        #self.ask_user = true
        self.user_filter_for_console = :itself
        self.paper_trail_user_for_test_console = ->(users) {
          users.admins.last
        }

        self.ask_reason = true
        self.require_reason = false
      end

      #attr_accessor :ask_user

      # Filter users with this proc. For example:
      #   ->(users) { users.admins) }
      attr_accessor :user_filter_for_console

      # A proc that returns a user if you ever run `rails console` in test
      # environment (where you probably won't have any real data)
      attr_accessor :paper_trail_user_for_test_console

      attr_accessor :ask_reason
      attr_accessor :require_reason

      class << self
        def configure
          yield self
        end
      end
    end
  end
end
