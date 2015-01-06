module UserHelper
  def user_attrs
    %w(uid full_name nickname mail preferredLanguage admissionYear loginShell telephonenumber cn notifyBy push_services)
  end

  def attr_or_not_entered(user, a)
    value = user.send(a)

    return service_to_image(value) if a == 'notifyBy'

    return content_tag(:em, t('not_entered'), class: 'not-entered') if value.nil?

    return t(value) if a == 'preferredLanguage'

    return push_service_image(value) if a == 'push_services' && value.any?

    value
  end

  # Make image tags out of all the current push services
  def push_service_image(services)
    services.map do |s|
      "#{service_to_image(s[:service])} "
    end.join.html_safe
  end

  # Make an image tag out of a service name.
  # Default to mail
  def service_to_image(service)
    s = service || :mail
    image_tag "#{s}.png", size: "24"
  end
end
