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
  namespace :add_modals do
    desc 'add modals to database'
    task :up do
      sql = %Q[
      CREATE TABLE IF NOT EXISTS modals (
        id serial PRIMARY KEY,
        message_id varchar NOT NULL,
        type varchar NOT NULL,
        object_id int
      );]

      query = ActiveRecord::Base.send(:sanitize_sql_array, [sql])
      ActiveRecord::Base.connection.exec_query(query)
    end

    desc 'remove modals from database'
    task :down do
      sql = "DROP TABLE IF EXISTS modals;"

      query = ActiveRecord::Base.send(:sanitize_sql_array, [sql])
      ActiveRecord::Base.connection.exec_query(query)
    end
  end
end
