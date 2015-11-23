class Presenter < ActiveRecord::Base

  validates :last, presence: true
  validates :first, presence: true
  validates :email, presence: true, format: { with: /@/, on: :create }
  validates :affiliation, presence: true
  validates :title, presence: true
  validates :secret, presence: true, uniqueness: true

  belongs_to :conference
  has_and_belongs_to_many :attendees
end
