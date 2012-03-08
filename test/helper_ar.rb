require 'active_record'
require 'helper'

class MysqlInspectorActiveRecordpec < MysqlInspectorSpec

  register_spec_type(self) { |desc| desc =~ /activerecord/ }

  before do
    create_mysql_database
    unless ActiveRecord::Base.connected?
      ActiveRecord::Base.establish_connection(
        :adapter => :mysql2,
        :database => database_name,
        :username => "root",
        :password => nil
      )
    end
  end

  # Execute all of the fixture migrations.
  #
  # Returns nothing.
  def run_active_record_migrations!
    ActiveRecord::Migration.verbose = false
    ActiveRecord::Migrator.migrate(["test/fixtures/migrate"])
  end

  # Get access to the mysql database via the CLI interface.
  #
  # Returns a MysqlInspector:Access::AR.
  def ar_access
    MysqlInspector::Access::AR.new(database_name, ActiveRecord::Base.connection)
  end

end