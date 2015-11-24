module SubscriptionHelper
  # Notifies all subscribers of a given application, with application_id
  # Expects 'tokens' of format; [{message: "Message", title: "Title", url: "http://google.se" , url_title: "google"}]
  def notify_subscibers(app_id, tokens)
    subscriptions = Subscription.where(:application_id => app_id)
    subscriptions.each do |subscription|
      subscription.publish(tokens)
    end
  end
  # Adds a subscription to the app for the given user, currently only supports mail.
  def add_subscription(user_id, app_id)
    # Create a subscription to tie the user and the app.
      subscription = Subscription.create(user_id: user_id, application_id: app_id)
    # Create a service data to specify the notification service.
      servicedata = ServiceData.create(user_id: user_id, subscription_id: subscription.id, push_client: "mail")
    # Add servicedata to the subscription.
      subscription.service_data_id = servicedata.id
      subscription.save!
  end

  def delete_subscription(user_id, app_id)
    subscription = Subscription.where(user_id: user_id, application_id: app_id).first
    servicedata = ServiceData.where(user_id: user_id, subscription_id: subscription.id)
    subscription.delete
    servicedata.delete_all
  end

  def subscription_exists(user_id, app_id)
    Subscription.where(user_id: user_id, application_id: app_id).exists?
  end

  def services
    [:pushbullet, :pushover, :mail]
  end
end
