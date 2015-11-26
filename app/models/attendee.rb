class Attendee < ActiveRecord::Base

  belongs_to :conference
  has_and_belongs_to_many :presenters

  validates :last, presence: true
  validates :first, presence: true
  validates :email, presence: true, uniqueness: { scope: :conference, case_sensitive: false }, format: { with: /@/, on: :create }
  validates :affiliation, presence: true

  def validate
    if presenters.length > conference.poster_limit
      errors.add_to_base("#{first} #{last} cannot be invited to anymore posters.")
    end
  end

end
