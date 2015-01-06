class LdapUser < ActiveLdap::Base
  ldap_mapping dn_attribute: 'uid',
               prefix: 'ou=it,ou=people'


  def full_name
    @full_name ||= "#{gn} '#{nickname}' #{sn}"
  end

  def push_services
     @push_services ||= self.pushService.map do |s|
       service, device, key = s.split ";"
       {service: service, device: device, api: key}
     end
  end

  def db_user
    @db_user ||= User.find_or_create_by(cid: uid)
  end
end
