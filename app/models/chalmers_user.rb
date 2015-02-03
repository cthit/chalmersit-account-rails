class ChalmersUser
  include ActiveModel::Model
  attr_accessor :cid, :password

  validates :cid, presence: true, length: {within: 3..10}, format: {with: /\A[a-z]+[0-9a-z]*\z/, }
  validate :valid_password?
  validate :havent_already_registered?

  def havent_already_registered?
    if cid.present?
      if LdapUser.search(attribute: :uid, value: cid, limit:1).any?
        errors.add(:cid, :already_registered)
      end
    end
  end

  def valid_password?
    unless password.present?
      errors.add(:password, :blank)
    end
    unless password.size > 10
      # Chalmers password policy specifies a minimum length of 10
      errors.add(:password, :too_short)
    end

    if errors.empty?
      begin
        krb5 = Kerberos::Krb5.new
        # Authenticate against Kerberos. raises Kerberos::Krb5::Exception on wrong password.
        krb5.get_init_creds_password cid, password
      rescue Kerberos::Krb5::Exception
        errors.add(:base, :wrong_cid_or_pass)
      end
    end
  end



  def mail
    init_ldap
    @ldap.mail
  end

  def firstname
    init_ldap
    @ldap.gn
  end

  def lastname
    init_ldap
    @ldap.sn
  end

  def it_student?
    init_ldap
    @ldap.it?
  end

  private
    def init_ldap
      begin
        @ldap ||= ChalmersLdapUser.find(cid)
      rescue NoMethodError
        # This occurs sometimes when the connection to Chalmers LDAP is lost...
        ChalmersLdapUser.setup_connection(ChalmersLdapUser.remove_connection)
        @ldap = ChalmersLdapUser.find(cid)
      end
    end
end
