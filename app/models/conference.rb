class Conference < ActiveRecord::Base

  validates :name, presence: true
  validates :invite_limit, numericality: { greater_than_or_equal_to: 1 }
  validates :poster_limit, numericality: { greater_than_or_equal_to: 1 }

  belongs_to :user
  has_many :attendees
  has_many :presenters

  def open?
    self.presenters_emailed && !self.attendees_emailed
  end

end
