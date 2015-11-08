# Data model to show which tybes of subscriptions the application supports
class SubscribableType < ActiveRecord::Base
  belongs_to :application
end
