# A Subscription is called when a application wants to notify its subscibers
class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :application
  belongs_to :service_data

  def publish(tokens)
    service_data.send(tokens)
  end
end
