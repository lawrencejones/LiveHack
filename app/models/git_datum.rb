class GitDatum < ActiveRecord::Base
  attr_accessible :repo, :time, :user
end
