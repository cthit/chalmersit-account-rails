module Devise
  module Strategies
    class ItLdap < Base
      def valid?
        params['cid'] && params['password']
      end

      def authenticate!
        begin
          u = LdapUser.find(params['cid']).bind(params['password'])
        rescue ActiveLdap::EntryNotFound
          return fail! 'No user exists'
        rescue ActiveLdap::AuthenticationError
          return fail! 'Invalid password'
        end
        success!(u)
      end
    end
  end
end
