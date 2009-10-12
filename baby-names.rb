require 'rubygems'
require 'sinatra'
require 'sass'
require 'lib/partials'
require 'dm-core'
require 'dm-timestamps'
require 'dm-validations'
require 'sinatra-authentication'

Dir["#{File.dirname(__FILE__)}/models/*.rb"].each {|f| require f}
Dir["#{File.dirname(__FILE__)}/controllers/*.rb"].each {|f| require f}

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/names.sqlite3")
DataMapper.auto_upgrade!

enable :sessions

helpers do
  include Sinatra::Partials
  
  def voted_for?(name)
    return false unless name.votes.size > 0
    name.votes.first(:ip => @env['REMOTE_ADDR']) ? true : false
  end

  def clearfix
    "<div class='clearfix'></div>"
  end
end

get '/stylesheets/stylesheet.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :stylesheet
end

get '/stylesheets/reset.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :reset
end

get '/' do
  erb :homepage
end
