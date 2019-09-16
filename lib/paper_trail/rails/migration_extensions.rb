module PaperTrail
  module Rails
    module RecordMigrationNameInVersion
      def exec_migration(conn, direction)
        PaperTrail.request.whodunnit = nil
        PaperTrail::Rails.set_default_metadata
        PaperTrail.update_metadata(
          command: "rails db:migrate: #{self.name} (#{direction})"
        )
        super
      end
    end
  end
end

ActiveRecord::Migration.class_eval do
  prepend PaperTrail::Rails::RecordMigrationNameInVersion
end
