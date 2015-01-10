require 'net/https'

url = URI.parse("https://api.pushover.net/1/messages.json")
req = Net::HTTP::Post.new(url.path)
users = []

res = Net::HTTP.new(url.host, url.port)
res.use_ssl = true
res.verify_mode = OpenSSL::SSL::VERIFY_PEER

res.start do |http|
  users.each do |u|
    req.set_form_data({
      :token => Rails.applications.secrets.pushover,
      :user => u,
      :message => "hello world",
    })
    response = http.request(req)
    p response.body
  end
end
