module NotificationHelper

  def notify_subscibers(app_id, tokens)
    subscriptions = Subscription.where(:application_id => app_id)
    subscriptions.each do |sub|
      sub.publish(tokens)
    end
  end
  def services
    [:pushbullet, :pushover, :mail]
  end
end
