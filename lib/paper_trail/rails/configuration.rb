module PaperTrail
  module Rails
    class Configuration
      def initialize
        config = self

        config.select_user_filter = :itself
        config.select_user_other_allowed_values = ['system', 'admin']
        config.source_location_filter = ->(line) { !line.match /paper_trail/ }
      end

      # Filter proc to use to show a list of users in select_user helper. For example:
      #   ->(users) { users.admins) }
      # or
      #   ->(users) { users.none) }
      # Can be also be a symbol or anything that responds to to_proc.
      attr_accessor :select_user_filter

      attr_accessor :select_user_other_allowed_values

      attr_accessor :source_location_filter
    end
  end
end
