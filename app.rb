require 'sinatra'
require 'heroku'
require 'coffee-script'
require 'less'

get "/" do
	haml :index	
end