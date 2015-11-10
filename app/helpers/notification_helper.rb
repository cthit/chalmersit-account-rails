module NotificationHelper
  # Notifies all subscribers of a given application, with application_id
  # Expects 'tokens' of format; [{message: "Message", title: "Title", url: "http://google.se" , url_title: "google"}]
  def notify_subscibers(app_id, tokens)
    subscriptions = Subscription.where(:application_id => app_id)
    subscriptions.each do |subscription|
      subscription.publish(tokens)
    end
  end
  def services
    [:pushbullet, :pushover, :mail]
  end
end
