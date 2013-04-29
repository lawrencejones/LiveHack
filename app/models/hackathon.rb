class Hackathon < ActiveRecord::Base
  attr_accessible :desc, :end, :location, :name, :scheduleItems, :start

  has_many :users
end
