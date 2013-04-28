class ScheduleItem < ActiveRecord::Base
  attr_accessible :iconUrl, :isMajor, :name, :time
end
