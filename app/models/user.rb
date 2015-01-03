class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :validatable, :lockable, :timeoutable and :omniauthable

  # for later: :registerable,
  devise :recoverable, :rememberable, :trackable

  delegate :full_name, to: :ldap_user

  def ldap_user
    @ldap_user ||= LdapUser.find(cid)
  end

  attr_accessor :password
end
