class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :validatable, :lockable, :timeoutable and :omniauthable

  # for later: :registerable,
  devise :ldap_authenticatable, :recoverable, :rememberable, :trackable

  def ldap_user
    @ldap_user ||= LdapUser.find_cached(cid)
  end

  def method_missing(meth)
    ldap_user.send(meth)
  end

  attr_accessor :email, :password
end
