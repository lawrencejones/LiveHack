class Hackathon < ActiveRecord::Base
  attr_accessible :desc, :end, :location, :name, :start

  has_many :users
  has_many :teams
  has_many :schedule_items
  has_many :proposals, :through => :teams
end
