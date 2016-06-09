class Notifier < ApplicationMailer

  def request_selections(presenter, subject, message, deadline)
    @recipient = presenter
    @message = message
    @deadline = deadline
    mail(to: @recipient.email, cc: @recipient.conference.email, subject: subject)
  end

  def invite(attendee, subject, message)
    @recipient = attendee
    @message = message
    mail(to: @recipient.email, cc: @recipient.conference.email, subject: subject)
  end

end
