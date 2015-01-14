require 'notifications/notify'
require 'net/https'
#require 'JSON'

module ChalmersIT
  class Pushover < Notify

  private
  def self.setup_request(url, port)
    res = Net::HTTP.new(url, port)
    res.use_ssl = true
    res.verify_mode = OpenSSL::SSL::VERIFY_PEER
    return res
  end


    @@push_url = URI.parse("https://api.pushover.net/1/messages.json")
    @@verify_url = URI.parse("https://api.pushover.net/1/users/validate.json")

    public
    def self.verify(user, device = "")
      self.info(user, device)[:status] == 1
    end

    def self.info(user, device = "")
      res = self.setup_request @@verify_url.host, @@verify_url.port
      req = Net::HTTP::Post.new(@@verify_url.path)

      res.start do |http|
        req.set_form_data({
          token: Rails.application.secrets.pushover,
          user: user,
          device: device,
        })
        response = http.request(req)
        JSON.parse(response.body).symbolize_keys
      end
    end

    # Expects a list of users in this format: [{:user: "apikey", device: "nexus6"}]
    def self.notify(users, tokens)
      res = self.setup_request @@push_url.host, @@push_url.port
      req = Net::HTTP::Post.new(@@push_url.path)

      # open a single connection and send all the messages over that connection
      res.start do |http|
        users.each do |user|
          req.set_form_data({
            token: Rails.application.secrets.pushover,
            user: user[:user],
            device: user[:device],
            message: tokens[:message],
            title: tokens[:title],
            url: tokens[:url],
            url_title: tokens[:url_title]
          })
          response = http.request(req)
          puts "Pushover responded with #{response.code} #{response.msg}\nPushing to user #{user} yielded response: #{response.body}"
        end
      end
    end
  end

end
