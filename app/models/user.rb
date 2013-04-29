class User < ActiveRecord::Base
  attr_accessible :email, :name, :username

  validates :name,     :presence => true
  validates :username, :presence => true
  validates :email,    :presence => true

  has_many :hackathons

end
