module UserHelper
  def user_attrs
    %w(uid full_name nickname mail member_of preferredLanguage admissionYear telephonenumber display_name notifyBy push_services)
  end

  def attr_or_not_entered(user, a)
    value = user.send(a)

    return service_to_image(value) if a == 'notifyBy'

    return content_tag(:em, t('not_entered'), class: 'not-entered') if value.nil?

    return t(value) if a == 'preferredLanguage'

    return push_service_image(value) if a == 'push_services' && value.any?

    return member_of(value) if a == 'member_of'

    value
  end

  # Make image tags out of all the current push services
  def push_service_image(services)
    services.keys.map do |s|
      service_to_image(s)
    end.join(' ').html_safe
  end

  # Make an image tag out of a service name.
  # Default to mail
  def service_to_image(service)
    service ||= :mail
    image_tag "#{service}.png", size: "24", title: service
  end

  def member_of(members)
    return content_tag(:em, t('non_member'), class: 'not-entered') if members.empty?
    members.map do |m|
      m.cn
    end.join ", "
  end

  def push_services
    [
      {name: 'pushover', maxtoken: 30, maxdevice: 25, url: 'https://pushover.net'},
      {name: 'pushbullet', maxtoken: 32, maxdevice: 16, url: 'https://pushbullet.com'}
    ]
  end

  def whoose_profile user
    if current_user && current_user == user.db_user
      "your_profile"
    else
      "their_profile"
    end
  end

end
