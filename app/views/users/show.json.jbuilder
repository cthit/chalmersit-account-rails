json.extract! @user, :uid, :full_name, :nickname, :mail,
  :acceptedUserAgreement, :preferredLanguage, :admissionYear,
  :telephonenumber, :display_name
json.groups @user.member_of.map { |g| g.cn }
json.admin @user.admin?
if current_user.admin?
  json.dn @user.dn.to_s
end
