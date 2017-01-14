require 'rubygems'
require 'bundler/setup'
Bundler.require(:default, ENV["RACK_ENV"] || 'development')

require "logger"
require 'yaml'

$logger = Logger.new($stdout)

DATABASE_CONFIG = YAML.load_file('./config/database.yml')
NORAML_CONFIG = YAML.load_file('./config/enviroments.yml')

if ENV['RACK_ENV'] == 'production'
  DB = Sequel.postgres(DATABASE_CONFIG['production'])
else
  DB = Sequel.postgres(DATABASE_CONFIG['development'])
end

# # setup database extensions
# DB.extension :pg_array
# DB.extension :pg_hstore
# DB.extension :pg_json

# string extension
class Object
  def blank?
    self == '' or self.nil?
  end
end

Sequel::Model.plugin :timestamps
Sequel::Model.plugin :json_serializer

# setup cuba plugins
Dir["./app/plugin/*.rb"].each { |file| require file }
Cuba.plugin Cuba::Sugar::As
Cuba.plugin Cuba::Hawk::Auth

# require v1, v2, v3
Dir["./app/api/*.rb"].each { |file| require file }
# require files in sub directories
Dir["./app/api/*/*.rb"].each { |file| require file }
# require model
Dir["./app/model/*.rb"].each { |file| require file }
