class AttendeeKeyword < ActiveRecord::Base
  belongs_to :attendee
  belongs_to :keyword
end
