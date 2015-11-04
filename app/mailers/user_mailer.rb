class UserMailer < ApplicationMailer
  # Takes array of emails and sends invitation mail.
  def self.send_invitations(emails)
    emails.each do |email|
      new_invitation(email).deliver_now
    end
  end

  def new_invitation(email)
    @url = "http://0.0.0.0:3000/new"
    mail(to: email, subject: "Välkommen till IT-sektionen!")
  end
end
