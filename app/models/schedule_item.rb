class ScheduleItem < ActiveRecord::Base
  belongs_to :hackathon
  attr_accessible :label, :start_time, :icon_class
end
