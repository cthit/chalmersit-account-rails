class ServiceData < ActiveRecord::Base
  belongs_to :user
  belongs_to :subscription
  belongs_to :notification_service
end
