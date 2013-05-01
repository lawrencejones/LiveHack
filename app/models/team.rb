class Team < ActiveRecord::Base
  belongs_to :hackathon
  has_many :users
  has_many :proposals
  attr_accessible :name
end
