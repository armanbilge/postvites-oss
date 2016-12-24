class ApplicationMailer < ActionMailer::Base
  default from: Rails.configuration.x.from_email
  layout 'mailer'

  def from_with_name(name)
    "#{name} <#{Rails.configuration.x.from_email}>"
  end

end
