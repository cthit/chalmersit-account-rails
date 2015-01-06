module UserHelper
  def user_attrs
    %w(uid nickname mail gn sn preferredLanguage admissionYear nollanPhoto homeDirectory loginShell)
  end

  def attr_or_not_entered(user, a)
    value = user.send(a)

    return content_tag(:em, t('not_entered'), class: 'not-entered') if value.nil?

    return t(value) if a == 'preferredLanguage'

    value
  end
end
