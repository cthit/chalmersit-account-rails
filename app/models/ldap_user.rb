class LdapUser < ActiveLdap::Base
  include ActiveModel::Dirty
  ldap_mapping dn_attribute: 'uid',
               prefix: 'ou=it,ou=people'
  belongs_to :groups, class_name: 'LdapGroup', many: 'member', primary_key: 'dn'

  validates :mail, presence: true
  validates :nickname, presence: true
  validate :has_valid_display_format
  validate :has_valid_notifyBy
  validate :has_valid_api_keys

  define_attribute_methods :push_services

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
    @push_services ||= self.pushService(true).map do |s| # true = force return array of values
      service, key, device = s.split ';'
      [service, {device: device, api: key}]
    end.to_h
  end

  def push_services=(services)
    ps = services.map do |k, v|
      "#{k};#{v[:api]};#{v[:device]}" if v[:api].present?
    end

    push_services_will_change! unless ps == self.pushService
    @push_services = services
    self.pushService = ps
  end

  def db_user
    @db_user ||= User.find_or_create_by(cid: uid)
  end

  def has_valid_display_format
    errors.add(:display_name, :not_valid_format) unless LdapUser.display_formats.include? cn
  end

  def has_valid_notifyBy
    errors.add(:notifyBy, :not_set) unless self.notifyBy == 'mail' || push_services.include?(notifyBy)
  end

  def has_valid_api_keys
    return unless push_services_changed?

    push_services.each do |k, v|
        send "validate_#{k}", v[:api], v[:device]
    end
  end

  def validate_pushover user, device
    user_info = Chalmersit::Pushover.info user
    if user_info[:status] == 0
        errors.add("pushover:", user_info[:errors].first)
    elsif device.present? && (not user_info[:devices].include?(device))
        errors.add("pushover:", I18n.translate('activemodel.errors.models.ldap_user.unknown_device', known_devices: user_info[:devices].join(', ')))
    end
  end

  def validate_pushbullet user, device
    true
  end


  def self.display_formats
    ["%{firstname} '%{nickname}' %{lastname}", "%{firstname} %{lastname}", "%{nickname}", "%{lastname}"]
  end
end
