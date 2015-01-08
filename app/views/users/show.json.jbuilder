json.extract! @user, :uid, :full_name, :nickname, :mail, :preferredLanguage, :admissionYear, :telephonenumber, :display_name, :notifyBy, :push_services
json.groups @user.member_of.map { |g| g.cn }
