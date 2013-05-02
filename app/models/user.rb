class User < ActiveRecord::Base
  attr_accessible :email, :name, :username, :tags, :github_email, :signed_up

  validates :name,     :presence => true
  validates :username, :presence => true

  has_and_belongs_to_many :hackathons, :uniq => true
  has_many :teams, :through => :hackathons

end
