require 'devise/strategies/authenticatable'

module Devise
  module Strategies
    class ItLdapAuthenticatable < Authenticatable
      def valid?
        params_auth_hash && params_auth_hash[:cid] && params_auth_hash[:password]
      end

      def authenticate!
        begin
          user = LdapUser.first(params_auth_hash[:cid])
          unless ActiveLdap::UserPassword.valid? params_auth_hash[:password], user.userPassword
            fail!(:invalid)
          end

          db_user ||= user.db_user
          remember_me(db_user)
        rescue ActiveLdap::EntryNotFound
          return fail!(:not_found_in_database)
        end
        success!(db_user)
      end
    end
  end
end
