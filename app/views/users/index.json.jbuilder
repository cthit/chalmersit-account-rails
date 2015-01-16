json.array!(@users) do |u|
  json.extract! u, :uid, :display_name
  if current_user.admin?
    json.extract! u, :admissionYear, :full_name, :nickname, :mail,
      :acceptedUserAgreement, :preferredLanguage, :admissionYear,
      :telephonenumber, :display_name
    # FIXME: The following results in unreasonably many LDAP-queries. The culprit is member_of
    #json.groups u.member_of.map { |g| g.cn }
    #json.admin u.admin?
    json.dn u.dn.to_s
  end
end
