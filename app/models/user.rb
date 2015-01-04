class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :validatable, :lockable, :timeoutable and :omniauthable

  # for later: :registerable,
  devise :recoverable, :rememberable, :trackable

  delegate :full_name, :nickname, :mail, to: :ldap_user

  def ldap_user
    @ldap_user ||= LdapUser.find(cid)
  end

  def method_missing(meth)
    ldap_user.send(meth)
  end

  attr_accessor :email, :password

  alias_method :email, :mail
end
