class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :validatable, :lockable, :timeoutable and :omniauthable

  # for later: :registerable,
  devise :ldap_authenticatable, :recoverable, :rememberable, :trackable

  validates :gn, :sn, :mail, :admissionYear, :nickname, presence: true
  #validates :password, :password_confirmation, presence: true, length: { in: 8..100 }, on: :update
  # As specified by ITU. Minimum of 6 because 2 for region and min 5 for subscriber number
  validates :telephonenumber, allow_blank: true, numericality: { only_integer: true }, length: {minimum: 6, maximum: 15}
  #validates :acceptedUserAgreement, acceptance: true, allow_nil: false, on: :update

  attr_accessor :password_confirmation
  before_save :save_ldap

  def ldap_user
    @ldap_user ||= LdapUser.find_cached(cid)
  end

  def subscribed_applications
    subscriptions = Subscription.where(user_id: id)
    applications = []
    subscriptions.each do |single_sub|
      applications.push(Application.where(id: single_sub.application_id).first)
    end
    applications
  end

  def ldap_user= lu
    @ldap_user = lu
  end

  def acceptedUserAgreement
    method_missing :acceptedUserAgreement
  end

  def email
    method_missing :mail
  end

  def email= new_mail
    ldap_user.send :mail, new_mail
  end

  def password
    @tmp_pwd
  end

  def password= pwd
    @tmp_pwd = pwd

    # Note that this uses Crypt by default instead of ssha which phpldapadmin uses
    ldap_user.userPassword = ActiveLdap::UserPassword.crypt pwd
    @encrypted_password_changed = true
  end

  # Needed beacuse: http://stackoverflow.com/a/30891441
  def email_changed?
    false
  end
  def encrypted_password_changed?
    @encrypted_password_changed || false
  end

  def method_missing(meth)
    ldap_user.send(meth)
  end

  def rememberable_value
    self.remember_created_at.to_s
  end

  def save_ldap
    if valid?
      ldap_user.save
    end
  end
end
