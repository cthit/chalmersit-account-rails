class UserMailer < ApplicationMailer
  
  # Takes array of emails and sends invitation mail.
  def send_invitations(emails)
    layout_name = 'user_invitation'
    @url = "http://0.0.0.0:3000/new"
    mail(to: emails, subject: "Välkommen till IT-sektionen!") do |format|
      format.html { render layout: layout_name }
      format.text { render layout: layout_name }
    end
  end
end
