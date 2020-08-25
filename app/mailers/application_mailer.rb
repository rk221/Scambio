class ApplicationMailer < ActionMailer::Base
  default from: 'scambio.main@gmail.com'
  layout 'mailer'
  add_template_helper(BadgesHelper)
end
