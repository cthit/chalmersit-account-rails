class LdapUser < ActiveLdap::Base
  ldap_mapping dn_attribute: 'uid',
               prefix: 'ou=it,ou=people'


  def full_name
    @full_name ||= "#{gn} '#{nickname}' #{sn}"
  end

  def db_user
    @db_user ||= User.find_or_create_by(cid: uid)
  end
end
