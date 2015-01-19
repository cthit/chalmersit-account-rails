class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :application
  belongs_to :service_data
end
