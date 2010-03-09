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
    railtie_name :mongo_mapper

    # This sets the database configuration from Configuration#database_configuration
    # and then establishes the connection.
    initializer "mongo_mapper.initialize_database" do |app|
      conf = app.config.database_configuration[Rails.env]
      conn = Mongo::Connection.new(conf['host'], conf['port'])
      if conf['username']
        conn.authenticate(conf['username'], conf['password']) || raise("Invalid MongoDB Authentication")
      end
      MongoMapper.database = conf['database']
    end
  end
end
