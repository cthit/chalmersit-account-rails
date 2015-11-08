class ApplicationMailer < ActionMailer::Base
  default from: "no-reply@chalmers.it"
  layout 'mailer'
end
