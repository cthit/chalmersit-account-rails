require 'notifications/notify'
require 'net/https'

module ChalmersIT
  class Pushover < Notify

    @@url = URI.parse("https://api.pushover.net/1/messages.json")
    @@req = Net::HTTP::Post.new(@@url.path)

    def self.notify(users, title, message)

      res = Net::HTTP.new(@@url.host, @@url.port)
      res.use_ssl = true
      res.verify_mode = OpenSSL::SSL::VERIFY_PEER

      # open a single connection and send all the messages over that connection
      res.start do |http|
        users.each do |user|
          @@req.set_form_data({
            token: Rails.application.secrets.pushover,
            user: user,
            message: message,
            title: title
          })
          response = http.request(@@req)
          p response.body
        end
      end
    end

  end
end
