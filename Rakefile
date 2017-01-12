task default: %w{server}

desc "start server"
task :server do
  exec "shotgun --server=thin --port=3000 config.ru"
end

desc "start console"
task :c do
  require 'pry'
  require './app'
  Pry.start
end

task :test do
  exec "cutest test/*.rb"
end

namespace :db do
  require 'yaml'
  require 'sequel'
  Sequel.extension :migration, :core_extensions

  dc = YAML.load_file('./config/database.yml')
  if ENV['RACK_ENV'] == 'production'
    DBM = Sequel.postgres(dc['production'])
  else
    DBM = Sequel.postgres(dc['development'])
  end

  desc "Prints current schema version"
  task :version do
    version = if DBM.tables.include?(:schema_info)
      DBM[:schema_info].first[:version]
    end || 0

    puts "Schema Version: #{version}"
  end

  desc "Perform migration up to latest migration available"
  task :migrate do
    Sequel::Migrator.run(DBM, "db/migrations")
    Rake::Task['db:version'].execute
  end

  desc "Perform rollback to specified target or full rollback as default"
  task :rollback, :target do |t, args|
    args.with_defaults(:target => 0)

    Sequel::Migrator.run(DBM, "db/migrations", :target => args[:target].to_i)
    Rake::Task['db:version'].execute
  end

  desc "Perform migration reset (full rollback and migration)"
  task :reset do
    Sequel::Migrator.run(DBM, "db/migrations", :target => 0)
    Sequel::Migrator.run(DBM, "db/migrations")
    Rake::Task['db:version'].execute
  end

end
