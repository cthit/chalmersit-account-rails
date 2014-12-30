class LdapUser < ActiveLdap::Base
  ldap_mapping dn_attribute: 'uid',
               prefix: 'ou=it,ou=people'


  def full_name
    @full_name ||= "#{gn} '#{nickname}' #{sn}"
  end
end
