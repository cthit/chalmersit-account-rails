class ServiceData < ActiveRecord::Base
  belongs_to :user

  def notify(tokens)
    push_client.split(";").each do |client|
      if client == "pushover"
        users = []
        devices.split(";").each do |device|
          users.push({:user => get_service_key("pushover"), device: device})
        end
        Chalmersit::Pushover.notify(users, tokens)
      elsif client == "mail"
        UserMailer.send_notification(LdapUser.find(User.find(user_id).cid).mail, tokens).deliver_now
      else
        puts "not yet implemented"
      end
    end
  end

  private
  def get_service_key(service)
    push_services = LdapUser.find(user.cid).pushService.split(";")
    index = push_services.find_index(service)# gets the index where the service
    push_services[index + 1] # selects the key which belongs to the service
  end
end
