json.extract! @user, :full_name, :nickname, :mail,
  :accepted_user_agreement, :preferred_language, :admission_year,
  :telephone_number, :given_name, :surname, :display_name
json.groups @user.member_of.map { |g| g.cn }
json.admin @user.admin?
if policy(@user).admin?
  json.dn @user.dn.to_s
end
