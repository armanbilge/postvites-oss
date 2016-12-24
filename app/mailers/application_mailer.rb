class ApplicationMailer < ActionMailer::Base
  default from: Rails.configuration.x.from_email
  layout 'mailer'
end
