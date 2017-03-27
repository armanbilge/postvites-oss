class Invitation < ActiveRecord::Base

  belongs_to :attendee
  belongs_to :presenter

  validate :within_poster_limit, on: :create
  validate :within_invite_limit, on: :create

  private

  def within_poster_limit
    errors[:base] << "#{attendee.first} #{attendee.last} cannot be invited to anymore posters." if attendee.presenters.count >= attendee.conference.poster_limit
  end

  def within_invite_limit
    errors[:base] << "You cannot invite anymore attendees." if presenter.attendees.count >= presenter.conference.invite_limit
  end

end
