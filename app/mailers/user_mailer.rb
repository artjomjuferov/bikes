class UserMailer < ApplicationMailer
  default from: 'no-reply@bikes.com'

  def certification_received(user:, pdf_path:)
    attachments['cert.pdf'] = File.read(pdf_path)
    mail(to: user.email, subject: 'Congrats on a new certificate')
  end
end
