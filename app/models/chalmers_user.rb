class ChalmersUser
  include ActiveModel::Model
  attr_accessor :cid, :password

  validates :cid, presence: true, length: {within: 3..10}, format: {with: /\A[a-z]+[0-9a-z]*\z/, }
  validate :valid_password?

  def valid_password?
    unless password.present?
      errors.add(:password, :blank)
    end
    unless password.size > 10
      # Chalmers password policy specifies a minimum length of 10
      errors.add(:password, :too_short)
    end

    # Try to bind to Chalmers ldap
    @ldap = ChalmersLdapUser.valid_password? cid, password
    unless @ldap[:valid]
      errors.add(:password, :wrong_cid_or_pass)
    end
  end
end
