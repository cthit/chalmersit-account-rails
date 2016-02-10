class LdapGroup < Activedap
  ldap_mapping dn_attribute: 'cn',
               prefix: 'ou=fkit,ou=groups',
               classes:  ['groupOfNames', 'posixGroup','top', 'itGroup'],
               scope: :sub
  after_save :invalidate_my_cache, :invalidate_all_cache

  validates :displayName, :cn, :description, :gidNumber, presence: true
  validate :unique_gidnumber, on: :update
  validate :members_exists?, on: :update

  GROUP_BASE = 'ou=groups,dc=chalmers,dc=it'

  attr_accessor :container

  #Gets post of member
  def pos_of_member dn
    Rails.cache.fetch("#{cn}/#{dn}/pos") do
      uid = dn.rdns.first["uid"]
      post = positions.find{|u| u.split(";")[1] == uid}
      return "" if post.nil?
      post.split(";").first + ": "
    end
  end

  def members
    @members ||= Rails.cache.fetch("#{cn}/members") do
      LdapUser.find(members_as_dn)
    end
  end

  # Returns array of positions one layer deep ["POST;CID", "POST;CID", "POST;CID"]
  def positions
    Rails.cache.fetch("#{cn}/positions") do
      positions = position(true)
      member(true).each do |m|
        if LdapGroup.dn_is_group? m
          positions += (LdapGroup.find(m).position(true))
        end
      end
      positions
    end
  end

  def self.all_cached
    @all ||= Rails.cache.fetch(all_groups_cache_key) do
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
    displayName
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
      return @users if @users.present?

      # False is the users, true groups
      grouped = member(true).group_by{|g| LdapGroup.dn_is_group? g}
      @users = grouped[false] || []
      groups = grouped[true] || []

      groups.each do |g_dn|
        group_users = LdapGroup.find(g_dn).member.group_by{|g| LdapGroup.dn_is_group? g}[false]
        @users.push(*group_users)
      end
      @users
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

    def unique_gidnumber
      other = LdapGroup.search(attribute: :gidnumber, value: gidNumber, attributes: ['cn', 'gidNumber'], limit: 1)
      if other.any?
        other_cn = other.first[1]['cn'].first
        unless other_cn == cn
          errors.add(:gidNumber, "The choosen GID (#{gidNumber}) is already used by #{other_cn}")
        end
      end
    end

    def members_exists?
      # Returns two arrays, the first containing the groups, the second containing users
      partitioned = member(true).partition{|m| LdapGroup.dn_is_group? m}

      partitioned[0].map! { |e| LdapGroup.exists? e  }
      partitioned[1].map! { |e| LdapUser.exists? e }
      unless partitioned.flatten.all?
        errors.add(:no_member, "One or more members doesn't exist")
      end
    end
end
