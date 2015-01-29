class ChalmersLdapUser < ActiveLdap::Base
  setup_connection host: 'ldap.chalmers.se', base: 'dc=chalmers,dc=se'
  ldap_mapping dn_attribute: 'uid',
               prefix: 'ou=people',
               classes: ['inetOrgPerson']

  GROUP_BASE = 'cn=pr_ch_tkite,ou=groups,dc=chalmers,dc=se'

  def it?
    @it ||= search(filter: "member=#{dn}", scope: :base, attributes: ['memberOf'], base: GROUP_BASE).any?
  end

  def self.valid_password?(cid, passwd)
    begin
      user = ChalmersLdapUser.find(cid)
      user.bind passwd
      ChalmersLdapUser.remove_connection
      {valid: true, user: user}
    rescue ActiveLdap::AuthenticationError, ActiveLdap::EntryNotFound
      {valid: false, user: user}
    end
  end
end
