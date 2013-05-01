class Hackathon < ActiveRecord::Base
  attr_accessible :eid, :name, :start, :end, :location, :description

  has_and_belongs_to_many :users
  has_many :teams
  has_many :schedule_items
  has_many :proposals, :through => :teams
end
