class Notifier < ApplicationMailer

  def request_selections(presenter, subject, message, deadline)
    @recipient = presenter
    @message = message
    @deadline = deadline
    mail(from: from_with_name(@recipient.conference.name), to: @recipient.email, cc: @recipient.conference.email, subject: subject)
  end

  def invite(attendee, subject, message)
    @recipient = attendee
    @message = message
    mail(from: from_with_name(@recipient.conference.name), to: @recipient.email, cc: @recipient.conference.email, subject: subject)
  end

end
