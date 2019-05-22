require "paper_trail/rails/version"
require "paper_trail/rails/paper_trail_extensions"
require "paper_trail/rails/configuration"

module PaperTrail
  module Rails
    class << self
      def configuration
        @configuration ||= Configuration.new
      end
      alias_method :config, :configuration

      def configure
        yield config
      end

      # Store some metadata about where the change came from, even for rake tasks, etc.
      def set_default_paper_trail_metadata
        PaperTrail.update_metadata(
          command: "#{File.basename($PROGRAM_NAME)} #{ARGV.join ' '}",
          source_location: caller.find { |line|
            line.starts_with? ::Rails.root.to_s and
           !line.starts_with? __FILE__
          }
        )
      end

      def select_paper_trail_user_or_system
        select_admin(
          filter: config.paper_trail_user_filter_for_console,
          other_allowed_values: ['system'],
          other_values_prompt: "or 'system'"
        )
      end

      def get_paper_trail_reason(required: false)
        reason = nil
        until reason.present? do
          print "What is the reason for this change? "
          reason = gets.chomp
          break unless required
        end
        reason
      end
    end
  end
end

require "paper_trail/rails/railtie" if defined?(Rails)
