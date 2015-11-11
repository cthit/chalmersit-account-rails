# Merely a representation of the application, used when displaying all the subscribable applications
class Application < ActiveRecord::Base
  has_many :subscribable_types
  mount_uploader :avatar, ApplicationAvatarUploader
  validates :name, presence: true, allow_blank: false
  validates :description, presence: true, allow_blank: false
  # Called to get a array of supported subscribable types
  def supported_subs
    ["pushover"]
  end
end
