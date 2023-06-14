# This needs to be required from lib/rails/commands/runner/runner_command.rb. Otherwise the original
# perform method gets called before we've even had a chance to modify it.
#
# To manually test this, run this from a Rails app that has this gem included:
#   rails runner 'pp PaperTrail.request.controller_info'

require_relative 'railtie'

module PaperTrail
  module Rails
    module RunnerCommandExtensions
      def perform(code_or_file = nil, *command_argv)
        PaperTrail.request.whodunnit = nil
        PaperTrail::Rails.set_default_metadata
        PaperTrail.update_metadata(
          command: "rails runner: #{code_or_file} #{command_argv.join(' ')}"
        )
        super
      end

      # Rails::Command::Base#create_command creates this alias too, and runner is what actually gets
      # called so we have to override the alias too.
      alias runner perform
    end
  end
end

module Rails
  module Command
    ( RunnerCommand)
    class RunnerCommand
      prepend ::PaperTrail::Rails::RunnerCommandExtensions
    end
  end
end

module PaperTrail
  module Rails
    class Railtie
      runner do |application|
        # Rails provides this callback that is invoked by RunnerCommand#peform before running the
        # provided code. But it doesn't pass in the args from perform.
      end
    end
  end
end
