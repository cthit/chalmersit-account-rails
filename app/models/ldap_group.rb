class LdapGroup < ActiveLdap::Base
  ldap_mapping dn_attribute: 'cn',
               prefix: 'ou=fkit,ou=groups',
               :classes => ['groupOfNames', 'posixGroup','top'],
               scope: :sub

  def members(recursive=true)
    #TODO: reduce number of queries
    users ||= []
    dns ||= self.member(true).each do |dn|
      unless dn_is_group?(dn) then
        users << LdapUser.find(dn)
      else
        users.push(*LdapGroup.find(dn).members(false)) if recursive
      end
    end
    users.uniq
  end

  def dn_is_group?(dn)
    group_base ||= ActiveLdap::DistinguishedName.parse("ou=groups,dc=chalmers,dc=it")
    begin
      # FIXME: Find prettier way to do this...
      dn - group_base
    rescue ArgumentError
      return false
    end
    true
  end

  def is_member?(user)
    members.include? user
  end

  def to_s
    cn
  end

end
