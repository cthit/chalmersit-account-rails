class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :validatable, :lockable, :timeoutable and :omniauthable

  # for later: :registerable,
  devise :ldap_authenticatable, :recoverable, :rememberable, :trackable

  validates :gn, :sn, :mail, :admissionYear, :nickname, presence: true
  validates :password, :password_confirmation, presence: true, length: { in: 8..100 }
  validates :password, confirmation: true
  # As specified by ITU. Minimum of 6 because 2 for region and min 5 for subscriber number
  validates :telephonenumber, allow_blank: true, numericality: { only_integer: true }, length: {minimum: 6, maximum: 15}
  validates :acceptedUserAgreement, acceptance: true, allow_nil: false

  attr_accessor :password, :password_confirmation

  def ldap_user
    @ldap_user ||= LdapUser.find_cached(cid)
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

  def method_missing(meth)
    ldap_user.send(meth)
  end
end
