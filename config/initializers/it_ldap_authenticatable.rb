require 'devise/strategies/authenticatable'

module Devise
  module Strategies
    class ItLdapAuthenticatable < Authenticatable
      def authenticate!
        begin
          user = LdapUser.find(params_auth_hash[:cid])

          this = params_auth_hash[:password].force_encoding('ascii-8bit')
          that = user.userPassword.force_encoding('ascii-8bit')
          unless ActiveLdap::UserPassword.valid? this, that
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
