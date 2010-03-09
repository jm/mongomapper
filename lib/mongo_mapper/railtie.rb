# Rails 3 Railtie, see ActiveRecord's Railtie for the astounding possibilities!

# http://github.com/rails/rails/blob/master/activerecord/lib/active_record/railtie.rb

require "mongo_mapper"
require "rails"
require "active_model/railtie"

# For now, action_controller must always be present with
# rails, so let's make sure that it gets required before
# here. This is needed for correctly setting up the middleware.
# In the future, this might become an optional require.
require "action_controller/railtie"

module MongoMapper
  class Railtie < Rails::Railtie
    # Sets up the MongoDB connection from the configuration options in database.yml
    # for the given environment 
    def self.setup_from_env(app, env)
      conf = app.config.database_configuration[env]
      MongoMapper.connection = Mongo::Connection.new(conf['host'], conf['port'])
      if conf['username']
        conn.authenticate(conf['username'], conf['password']) || raise("Invalid MongoDB Authentication")
      end
      MongoMapper.database = conf['database']
      conf
    end

    railtie_name :mongo_mapper

    rake_tasks do
      load "mongo_mapper/railtie/rails.rake"
    end

    # This sets the database configuration from Configuration#database_configuration
    # and then establishes the connection.
    initializer "mongo_mapper.initialize_database" do |app|
      self.class.setup_from_env(app, Rails.env)
    end
  end
end
