class LDAPUser
  def ldap_param(param)
    @connection.ldap_param_value(param)
  end

  def groups
    @connection.user_groups
  end

  def initialize
    @connection = Devise::LDAP::Adapter.ldap_connect(user_name)
  end
end
