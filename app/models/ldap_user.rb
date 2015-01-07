class LdapUser < ActiveLdap::Base
  ldap_mapping dn_attribute: 'uid',
               prefix: 'ou=it,ou=people'
  belongs_to :groups, class_name: 'LdapGroup', many: 'member', primary_key: 'dn'

  validates :mail, presence: true
  validates :nickname, presence: true
  validate :has_valid_display_format

  # The groups the user is a member of
  def member_of
    #TODO: reduce number of queries
    @member_of ||= begin
      memberof = self.groups
      all = LdapGroup.find(:all)

      (all - memberof).each do |g|
        if g.is_member?(self) then
          memberof << g
        end
      end
      memberof
    end
  end

  def full_name
    @full_name ||= "#{gn} #{sn}"
  end

  def display_name
    begin
      @display_name ||= cn % {firstname: gn, lastname: sn, nickname: nickname}
    rescue
      nil
    end
  end

  def push_services
    return nil if self.pushService.nil?
     @push_services ||= self.pushService.map do |s|
       service, device, key = s.split ";"
       {service: service, device: device, api: key}
     end
  end

  def db_user
    @db_user ||= User.find_or_create_by(cid: uid)
  end

  def has_valid_display_format
    errors.add(:display_name, :not_valid_format) unless LdapUser.display_formats.include? cn
  end

  def self.display_formats
    ["%{firstname} '%{nickname}' %{lastname}", "%{firstname} %{lastname}", "%{nickname}", "%{lastname}"]
  end
end
