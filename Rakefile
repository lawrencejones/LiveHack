#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

LiveHack::Application.load_tasks

task "start" => :environment do
	system 'rails s thin -p 4567'
end