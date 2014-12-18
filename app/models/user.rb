require 'ldap_user'
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  # for later: :registerable,
  devise :ldap_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  @@LDAP_ATTRS = {
    first_name: :givenName,
    last_name: :sn,
    nick: :displayName,
    email: :mail
  }

  def email_changed?
    false
  end

  def groups
    @groups ||= @ldap.groups
  end

  @@LDAP_ATTRS.each do |it_name, ldap_name|
    define_method it_name do
      ins = "@#{it_name}"
      return instance_variable_get ins if instance_variable_defined? ins
      instance_variable_set ins, ldap.ldap_param(ldap_name).try(&:join)
    end
  end

  def full_name
    @full_name ||= "#{first_name} '#{nick}' #{last_name}"
  end

  private

    def ldap
      @ldap ||= LDAPUser.new(self.cid)
    end
end
