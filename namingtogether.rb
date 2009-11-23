$KCODE = 'UTF-8'

require 'rubygems'
require 'sinatra'
require 'sass'
require 'dm-core'
require 'dm-timestamps'
require 'dm-validations'
require 'rack-flash'
require 'active_support/inflector'

%w(lib models routes).each do |path|
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
  
  def voted_for?(name)
    return false unless name.votes.size > 0
    name.votes.first(:ip => @env['REMOTE_ADDR']) ? true : false
  end

  def clearfix
    "<div class='clearfix'></div>"
  end

  def error_messages_for(model)
    return unless model.errors
    puts model.errors.inspect
    errors = model.errors.full_messages.collect {|message| "<p>#{message}</p>"}.join(" ")
    "<div id='errors'>#{errors}</div>"
  end

  def cycle(*items)
    @_cycle_reset = items
    @_cycle ||= items
    @_cycle.push @_cycle.shift
    @_cycle.first
  end

  def reset_cycle
    @_cycle = @_cycle_reset
  end

  def pluralize(num, word)
    return "1 #{word}" if num == 1
    [num, word.pluralize].join(' ')
  end

  def list_owner?
    logged_in? && current_user.lists.include?(@list)
  end
end

before do
  content_type 'text/html', :charset => 'utf-8'
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

