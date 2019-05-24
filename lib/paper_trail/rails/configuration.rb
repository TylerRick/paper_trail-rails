module PaperTrail
  module Rails
    class Configuration
      def initialize
        config = self

        config.select_user_filter = :itself
        config.select_user_other_allowed_values = ['system', 'admin']
        config.user_for_test = ->(users) {
          users.admins.last
        }
      end

      # Filter proc to use to show a list of users in select_user helper. For example:
      #   ->(users) { users.admins) }
      # or
      #   ->(users) { users.none) }
      # Can be also be a symbol or anything that responds to to_proc.
      attr_accessor :select_user_filter

      attr_accessor :select_user_other_allowed_values

      # A proc that returns a user if you ever run `rails console` in test
      # environment (where you probably won't have any real data)
      attr_accessor :user_for_test
    end
  end
end
