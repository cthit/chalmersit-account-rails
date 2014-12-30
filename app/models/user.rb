class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  # for later: :registerable,
  devise :recoverable, :rememberable, :trackable, :validatable

  def ldap_user
    @ldap_user ||= LdapUser.find(self.cid)
  end

  attr_accessor :password
end
