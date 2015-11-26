class Presenter < ActiveRecord::Base

  belongs_to :conference
  has_and_belongs_to_many :attendees

  validates :last, presence: true
  validates :first, presence: true
  validates :email, presence: true, format: { with: /@/, on: :create }
  validates :affiliation, presence: true
  validates :title, presence: true
  validates :secret, presence: true, uniqueness: true

  def validate
    if attendees.length > conference.invite_limit
      errors.add_to_base("You cannot invite anymore attendees.")
    end
  end

  def responded?
    attendees.length > 0
  end

  def to_param
    secret
  end

end
