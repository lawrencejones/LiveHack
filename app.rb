require 'sinatra'
require 'heroku'
require 'coffee-script'
require 'less'
require 'dm-core'  
require 'dm-timestamps'  
require 'dm-validations'  
require 'dm-migrations'
require 'sinatra/activerecord'
require './config/environments'  # config for db

# Models
require './models/attendee.rb'
# /Models

DataMapper.setup :default, ""

get "/" do
	haml :index	
end