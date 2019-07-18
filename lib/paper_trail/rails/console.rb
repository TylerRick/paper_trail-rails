require_relative 'configuration'
require_relative 'railtie'

module PaperTrail
  module Rails
    module Console
      class << self
      end

      class Configuration
        def initialize
          config = self

          config.ask_for_user      = true
          config.require_user      = false
          config.auto_reset_user   = false

          config.ask_for_reason    = true
          config.require_reason    = false
          config.auto_reset_reason = true

          config.user_for_test = ->(users) {
            users.last
          }
        end

        attr_accessor :ask_for_user
        attr_accessor :require_user
        attr_accessor :auto_reset_user

        attr_accessor :ask_for_reason
        attr_accessor :require_reason
        attr_accessor :auto_reset_reason

        # A proc that returns a user if you ever run `rails console` in test
        # environment (where you probably won't have any real data)
        attr_accessor :user_for_test

        class << self
          def configure
            yield self
          end
        end
      end
    end

    class Configuration
      def console
        @console ||= Console::Configuration.new
      end
    end

    class Engine
      initializer "paper_trail-rails.set_default_metadata" do |app|
        # There's no way to set up deferred evaluation of PaperTrail.request.controller_info from
        # here like we can with whodunnit, so abuse that property of PaperTrail.request.whodunnit to
        # set other metadata. Reserve the whodunnit field for storing the actual name or id of the
        # human who made the change.
        PaperTrail.request.whodunnit = ->() {
          PaperTrail::Rails.set_default_metadata
          nil
        }
      end

      console do
        config = PaperTrail::Rails.config
        PaperTrail.update_metadata command: "rails console"
        PaperTrail.request.whodunnit = ->() {
          PaperTrail::Rails.set_default_metadata
          @paper_trail_whodunnit ||= (
            if config.console.ask_for_user
              if ::Rails.env.test?
                user = config.console.user_for_test.(User.all)
              else
                puts "Before you make any changes... We need to know who is making the changes, to store in the PaperTrail version history."
                user = PaperTrail::Rails.select_user(required: config.console.require_reason)
                puts "Thank you, #{user}! Have a wonderful time!" if user
              end
              user.respond.id
            end
          )

          if config.console.ask_for_reason
            @paper_trail_reason ||= PaperTrail::Rails.get_reason(required: config.console.require_reason)
          end
          PaperTrail.update_metadata reason: @paper_trail_reason

          @paper_trail_whodunnit
        }


        if config.console.auto_reset_user || config.console.auto_reset_reason
          if defined?(Pry)
            Pry.hooks.add_hook(:after_eval, "paper_trail-rails-auto_reset") do |output, binding, pry|
              if config.console.auto_reset_user
                @paper_trail_whodunnit = nil
              end
              if config.console.auto_reset_reason
                @paper_trail_reason = nil
                PaperTrail.update_metadata reason: @paper_trail_reason
              end
            end
          else
            raise "Pry is required in order to use `auto_reset`. Please add pry-rails to your Gemfile or disable this in the config."
          end
        end
      end
    end
  end
end
