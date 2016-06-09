class Attendee < ActiveRecord::Base

  belongs_to :conference
  has_many :invitations
  has_many :presenters, through: :invitations
  has_many :attendee_keywords
  has_many :keywords, through: :attendee_keywords

  validates :last, presence: true
  validates :first, presence: true
  validates :email, presence: true, uniqueness: { scope: :conference, case_sensitive: false }, format: { with: /@/, on: :create }

  def vital
    "#{last}, #{first} (#{affiliation})"
  end

end
