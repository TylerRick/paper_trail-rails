module PaperTrail
  module Rails
    class Railtie < ::Rails::Railtie
      initializer "paper_trail-rails.set_default_paper_trail_metadata" do |app|
        # There's no way to set up deferred evaluation of PaperTrail.request.controller_info from
        # here like we can with whodunnit, so abuse that property of PaperTrail.request.whodunnit to
        # set other metadata. Reserve the whodunnit field for storing the actual name or id of the
        # human who made the change.
        PaperTrail.request.whodunnit = ->() {
          PaperTrail::Rails.set_default_paper_trail_metadata
          nil
        }
      end

      console do
        PaperTrail.update_metadata command: "rails console"
        PaperTrail.request.whodunnit = ->() {
          PaperTrail::Rails.set_default_paper_trail_metadata
          @paper_trail_whodunnit ||= (
            if ::Rails.env.test?
              user = config.paper_trail_user_for_test_console.(User.all)
            else
              puts "Before you make any changes... We need to know who is making the changes, to store in the PaperTrail version history."
              user = select_paper_trail_user_or_system
              puts "Thank you, #{user}! Have a wonderful time!"
            end
            user.respond.id
          )
          if config.ask_reason
            @paper_trail_reason ||= get_paper_trail_reason(required: config.require_reason)
          end
          PaperTrail.update_metadata reason: @paper_trail_reason
          @paper_trail_whodunnit
        }
      end
    end
  end
end


module RecordMigrationNameInVersion
  def exec_migration(conn, direction)
    PaperTrail.update_metadata(
      command: "rails db:migrate: #{self.name} (#{direction})"
    )
    super
  end
end
ActiveRecord::Migration.class_eval do
  prepend RecordMigrationNameInVersion
end
