class LdapGroup < ActiveLdap::Base
  ldap_mapping dn_attribute: 'cn',
               prefix: 'ou=fkit,ou=groups',
               :classes => ['groupOfNames', 'posixGroup','top'],
               scope: :sub
  has_many :members, class_name: "LdapUser", wrap: 'member', primary_key: 'dn'

  def users
    users ||= self.members.collect{|u| u.uid}
  end

  def to_s
    cn
  end

end
