class ChalmersLdapUser < ActiveLdap::Base
  setup_connection host: 'ldap.chalmers.se', base: 'dc=chalmers,dc=se'
  ldap_mapping dn_attribute: 'uid',
               prefix: 'ou=people'

  GROUP_BASE = 'cn=s_passer_prog_tkite,ou=groups,dc=chalmers,dc=se'

  def it?
    @it ||= search(filter: "memberUid=#{uid}", scope: :base, attributes: ['dn'], base: GROUP_BASE).any?
  end
end
