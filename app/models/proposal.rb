class Proposal < ActiveRecord::Base
  belongs_to :team
  has_one :hackathon, :through => :team
  attr_accessible :desc, :name, :skills
end
