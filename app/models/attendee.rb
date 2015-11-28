class Attendee < ActiveRecord::Base

  belongs_to :conference
  has_many :invitations
  has_many :presenters, through: :invitations

  validates :last, presence: true
  validates :first, presence: true
  validates :email, presence: true, uniqueness: { scope: :conference, case_sensitive: false }, format: { with: /@/, on: :create }
  validates :affiliation, presence: true

  def vital
    "#{last}, #{first} (#{affiliation})"
  end

end
