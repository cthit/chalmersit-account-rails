# Merely a representation of the application, used when displaying all the subscribable applications
class Application < ActiveRecord::Base
  before_create :generate_access_token

  has_many :subscribable_types

  mount_uploader :avatar, ApplicationAvatarUploader

  validates :name, presence: true, allow_blank: false
  validates :description, presence: true, allow_blank: false

  # Called to get a array of supported subscribable types
  def supported_subs
    ["mail"]
  end

  private
  def generate_access_token
    begin
      self.auth_token = SecureRandom.hex
    end while self.class.exists?(auth_token: auth_token)
  end
end
