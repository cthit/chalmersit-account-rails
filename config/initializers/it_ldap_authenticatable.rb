require 'devise/strategies/authenticatable'

module Devise
  module Strategies
    class ItLdapAuthenticatable < Authenticatable
      def valid?
        params_auth_hash && params_auth_hash[:cid] && params_auth_hash[:password]
      end

      def authenticate!
        begin
          ldap_user = LdapUser.find(params_auth_hash[:cid])
          ldap_user.bind(params_auth_hash[:password])

          user = ldap_user.db_user
          remember_me(ldap_user)
        rescue ActiveLdap::EntryNotFound
          return fail!(:not_found_in_database)
        rescue ActiveLdap::AuthenticationError
          return fail!(:invalid)
        end
        success!(user)
      end
    end
  end
end
