class LdapGroup < ActiveLdap::Base
  ldap_mapping dn_attribute: 'cn',
               prefix: 'ou=fkit,ou=groups',
               classes:  ['groupOfNames', 'posixGroup','top', 'itGroup'],
               scope: :sub

  GROUP_BASE = 'ou=groups,dc=chalmers,dc=it'

  def members
    @members_cache ||= {}
    @members ||= members_as_dn.lazy.map { |m| @members_cache[m] ||= LdapUser.find(m) }
  end

  def self.all
    @@all ||= self.find(:all)
  end

  def members_as_dn
    @members_dn ||= recursive_members(dn, true).uniq
  end

  def dn_is_group?(dn)
    dn.to_s.include? GROUP_BASE
  end

  def is_member?(user)
    members_as_dn.include? user.dn.to_s
  end

  def to_s
    cn
  end

  def function_localised locale
    localise_field function(true), locale
  end

  def description_localised locale
    localise_field description(true), locale
  end

  private
    def recursive_members(dn, recursive = true)
      users = []
      LdapGroup.find(dn).member(true).each do |dn|
        if not dn_is_group?(dn)
          users << dn
        elsif recursive
          users.push(*recursive_members(dn, false))
        end
      end
      users
    end

  def localise_field field, locale
    field.each do |f|
      split = f.split(';')
      if locale == split.first.to_sym
        return split.last
      end
    end
    field.first
  end
end
