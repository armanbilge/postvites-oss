class ApplicationMailer < ActionMailer::Base
  default from: 'no-reply@' + ENV['HOSTNAME']
  layout 'mailer'
end
