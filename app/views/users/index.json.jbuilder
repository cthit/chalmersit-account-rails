json.cache! 'all_users_json', expires_in: 10.minutes do
  json.array!(@users) do |u|
    json.extract! u, :uid, :display_name
    if policy(u).show?
      json.extract! u, :admissionYear, :full_name, :nickname, :mail,
        :acceptedUserAgreement, :preferredLanguage, :admissionYear,
        :telephonenumber, :display_name
      json.groups u.member_of.map { |g| g.cn }
      json.admin u.admin?
      if policy(u).admin?
        json.dn u.dn.to_s
      end
    end
  end
end
