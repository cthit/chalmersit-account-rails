class LdapGroup < Activedap
  ldap_mapping dn_attribute: 'cn',
               prefix: 'ou=fkit,ou=groups',
               classes:  ['groupOfNames', 'posixGroup','top', 'itGroup'],
               scope: :sub
  after_save :invalidate_my_cache, :invalidate_all_cache


  GROUP_BASE = 'ou=groups,dc=chalmers,dc=it'

  def members
    Rails.cache.fetch("#{cn}/members") do
      LdapUser.find(members_as_dn)
    end
  end

  def self.all_cached
    Rails.cache.fetch(all_groups_cache_key) do
      self.find(:all)
    end
  end

  def self.find_cached cn
    Rails.cache.fetch(cn) do
      self.find(:first, cn)
    end
  end

  # Will only return user dn:s
  def members_as_dn
    @members_dn ||= recursive_members().uniq
  end

  def self.dn_is_group?(dn)
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

  def cache_key
    "#{cn}/#{attributes.hash}"
  end

  def _dump level = 0
    attrs = attributes
    attrs['member'].map!(&:to_s)
    [dn.to_s, attrs].to_s
  end

  def self.all_groups_cache_key
    "all_ldap_groups"
  end

  def invalidate_all_cache
    Rails.cache.delete(LdapGroup.all_groups_cache_key)
  end

  def invalidate_my_cache
    Rails.cache.delete(cn)
    Rails.cache.delete("#{cn}/members")
  end

  private
    # Concat users of group members one layer deep
    def recursive_members()
      # False is the users, true groups
      grouped = member(true).group_by{|g| LdapGroup.dn_is_group? g} 
      users = grouped[false] || []
      groups = grouped[true] || []

      groups.each do |g_dn|
        group_users = LdapGroup.find(g_dn).member.group_by{|g| LdapGroup.dn_is_group? g}[false]
        users.push(*group_users)
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
