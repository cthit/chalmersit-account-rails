require 'devise/strategies/authenticatable'

module Devise
  module Strategies
    class ItLdapAuthenticatable < Authenticatable
      def authenticate!
        begin
          user = LdapUser.find(params_auth_hash[:cid])
          unless ActiveLdap::UserPassword.valid? params_auth_hash[:password], user.userPassword
            return fail!(:invalid)
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
