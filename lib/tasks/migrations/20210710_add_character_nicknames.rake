require 'active_record'
require 'erb'
require 'bundler'

BOT_ENV = ENV.fetch('BOT_ENV') { 'development' }
Bundler.require(:default, BOT_ENV)
db_yml = File.open('config/database.yml') do |erb|
  ERB.new(erb.read).result
end

db_config = YAML.safe_load(db_yml)[BOT_ENV]
ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDOUT)
ActiveRecord::Base.establish_connection(
  adapter: 'postgresql',
  host: db_config.fetch('host') { 'localhost' },
  database: db_config['database'],
  user: db_config['user'],
  password: db_config['password'],
  pool: 5
)

namespace :migrate do
  namespace :add_character_nicknames do
    desc 'add nicknames to characters table'
    task :up do
      sql = "ALTER TABLE characters ADD COLUMN IF NOT EXISTS nicknames varchar[];"

      query = ActiveRecord::Base.send(:sanitize_sql_array, [sql])
      ActiveRecord::Base.connection.exec_query(query)
    end

    desc 'remove modals from database'
    task :down do
      sql = "ALTER TABLE characters DROP COLUMN IF EXISTS nicknames;"

      query = ActiveRecord::Base.send(:sanitize_sql_array, [sql])
      ActiveRecord::Base.connection.exec_query(query)
    end
  end
end
