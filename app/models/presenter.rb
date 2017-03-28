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

  def available_attendees
    attendees.union(conference.available_attendees)
  end

  def vital
    "#{last}, #{first}#{ ' (' + affiliation + ')' unless affiliation.blank?}"
  end

  def presenter
    "#{first} #{last}#{ ' (' + affiliation + ')' unless affiliation.blank?}"
  end

  def date_time
    time_format = '%l:%M %p'
    "#{session_day.strftime('%a %b %e')}#{' ' + session_start.strftime(time_format).strip + ' to ' + session_end.strftime(time_format).strip unless session_start.nil?}"
  end

  def location_number
    "#{location}#{' #' + number.to_s unless number.nil? }"
  end

  def info(include_email=false)
    info = ''
    info += 'Title: ' + title
    info += "\nPresenter: " + presenter
    if include_email
      info += "\nEmail: " + email
    end
    unless session.nil?
      info += "\nSession: " + session
    end
    info += "\nDate/Time: " + date_time
    unless location.nil?
      info += "\nLocation: " + location_number
    end
    unless abstract.nil?
      info += "\nAbstract:\n#{abstract}"
    end
    info
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
