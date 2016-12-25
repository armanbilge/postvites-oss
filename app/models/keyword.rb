class Keyword < ActiveRecord::Base
  belongs_to :conference
  has_many :attendee_keywords
  has_many :attendees, through: :attendee_keywords
  validates :name, presence: true, uniqueness: { case_sensitive: false, scope: :conference }
end
