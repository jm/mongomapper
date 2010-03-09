namespace :mongodb do
  namespace :test do
    desc "Empty the test database"
    task :purge => :environment do
      conf = MongoMapper::Railtie.setup_from_env(Rails.application, 'test')
      MongoMapper.connection.drop_database(conf['database'])
    end
  end
end

# needed so Rails 3 can find tests
namespace :db do
  namespace :test do
    desc "Clear and load the test database."
    task :prepare => 'mongodb:test:purge'
  end
end