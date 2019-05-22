module PaperTrail
  module Rails
    module RecordMigrationNameInVersion
      def exec_migration(conn, direction)
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
