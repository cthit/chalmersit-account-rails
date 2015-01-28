class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :validatable, :lockable, :timeoutable and :omniauthable

  # for later: :registerable,
  devise :ldap_authenticatable, :recoverable, :rememberable, :trackable

  def ldap_user
    @ldap_user ||= LdapUser.find_cached(cid)
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
