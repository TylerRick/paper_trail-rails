require 'rails'
# When rails/commands/runner/runner_command.rb is invoked, it won't have already loaded
# active_record, so we need to load it to avoid getting uninitialized constant ActiveRecord.
require 'active_record'
require 'paper_trail'

require_relative 'rails/version'

# (In alphabetical order)
require_relative 'rails/configuration'
require_relative 'rails/console'
require_relative 'rails/general'
require_relative 'rails/migration_extensions'
require_relative 'rails/paper_trail_extensions'

module PaperTrail
  # This is the main module for this gem. Can't make it a class because
  # paper_trail gem already defines this module; otherwise I would have made
  # this a class.
  module Rails
    class << self
      def configuration
        @configuration ||= Configuration.new
      end
      alias_method :config, :configuration

      def configure
        yield config
      end

      # Store some metadata about where the change came from
      def set_default_metadata
        PaperTrail.update_metadata(
          command: default_command,
          source_location: caller.find { |line|
            line.starts_with? ::Rails.root.to_s and
            config.source_location_filter.(line)
          }
        )
      end

      def default_command
        program_name = File.basename($PROGRAM_NAME)
        returning = program_name
        returning << " #{rails_subcommand}" if program_name == 'rails'
        returning << " #{ARGV.join(' ')}" if ARGV.any?
        returning
      end

      def rails_subcommand
        regexp = %r{lib/rails/commands/\w+/(\w+)_command\.rb}
        if (frame = caller.detect { |f| f =~ regexp })
          frame.match(regexp)[1]
        end
      end

      def select_user(required: false)
        other_allowed_values = config.select_user_other_allowed_values
        other_values_prompt = " (or #{other_allowed_values.join(' or ')})" if other_allowed_values.present?
        General.select_user(
          filter:               config.select_user_filter,
          other_allowed_values: other_allowed_values,
          prompt: "Please enter a User id#{other_values_prompt}",
          required: required
        )
      end

      def get_reason(required: false)
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
