json.extract! @user, :uid, :display_name, :full_name, :nickname, :mail,
  :accepted_user_agreement, :preferred_language, :admission_year,
  :telephone_number, :given_name, :surname
json.avatar image_url(@user.profile_image)
json.groups @user.member_of.map { |g| g.cn }
json.positions @user.member_of.map { {g.cn => g.pos_of_member(@user.dn)} }
json.admin @user.admin?
if policy(@user).admin?
  json.dn @user.dn.to_s
end
