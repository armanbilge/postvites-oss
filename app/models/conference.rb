class Conference < ActiveRecord::Base
  belongs_to :user
  has_many :attendees
  has_many :presenters
end
