class Attendee < ActiveRecord::Base

  validates :last, presence: true
  validates :first, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: /@/, on: :create }
  validates :affiliation, presence: true

  belongs_to :conference
  has_and_belongs_to_many :presenters

end
