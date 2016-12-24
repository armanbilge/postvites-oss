class Presenter < ActiveRecord::Base

  belongs_to :conference
  has_many :invitations
  has_many :attendees, through: :invitations

  validates :last, presence: true
  validates :first, presence: true
  validates :email, presence: true, format: { with: /@/, on: :create }
  validates :title, presence: true
  validates :session_day, presence: true
  validate :session_day_must_be_in_future
  validates :secret, presence: true, uniqueness: true

  def vital
    "#{last}, #{first}#{ ' (' + affiliation + ')' unless affiliation.blank?}"
  end

  def responded?
    attendees.count > 0
  end

  def to_param
    secret
  end

  private

  def session_day_must_be_in_future
    if session_day.present? && !session_day.future?
      errors.add(:session_day, 'must be in the future')
    end
  end

end
