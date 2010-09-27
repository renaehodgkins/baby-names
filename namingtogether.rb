$KCODE = 'UTF-8'

require 'rubygems'
require 'sinatra'
require 'sass'
require 'dm-core'
require 'dm-timestamps'
require 'dm-validations'
require 'dm-migrations'
require 'rack-flash'
require 'active_support/inflector'

['lib', 'models', 'helpers', 'routes'].each do |path|
  Dir["#{File.dirname(__FILE__)}/#{path}/*.rb"].each {|f| require f}
end

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/names.sqlite3")
DataMapper.auto_upgrade!

use Rack::Flash

configure do
  enable :sessions
end

helpers do
  include Sinatra::Partials
  include NamingTogether::ApplicationHelper
end

before do
  content_type 'text/html', :charset => 'utf-8'
end

get '/stylesheets/stylesheet.css' do
  sass :stylesheet
end

get '/stylesheets/reset.css' do
  sass :reset
end

get '/' do
  erb :homepage
end

get '/about' do
  erb :about
end

