module UserHelper
  def user_attrs
    %w(uid full_name nickname mail telephonenumber member_of admissionYear preferredLanguage display_name profile_image)
  end

  def priv_attrs
    %w(uid preferredLanguage display_name)
  end

  # Returns true if I am able to view a privileged variable
  def can_i_view? attr
    if current_user.cid == @user.uid || current_user.admin?
      return true
    end
    !priv_attrs.include?(attr)
  end

  def show_attr? attr
    can_i_view?(attr) && @user.send(attr).present?
  end

  def attr_or_not_entered(user, a)
    value = user.send(a)

    return t(value) if a == 'preferredLanguage'

    return push_service_image(value) if a == 'push_services' && value.any?

    return member_of(value) if a == 'member_of'

    return image(value) if a == "profile_image"

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
      link_to m.displayName, group_path(m)
    end.join ", "
  end

  def push_services
    [
      {name: 'pushover', maxtoken: 30, maxdevice: 25, url: 'https://pushover.net'},
      {name: 'pushbullet', maxtoken: 32, maxdevice: 16, url: 'https://pushbullet.com'}
    ]
  end

  def whoose_profile user
    if current_user && current_user.cid == user.uid
      "your_profile"
    else
      "their_profile"
    end
  end

  def years_until_current years_back
    current = Time.new.year
    current - years_back+1..current
  end

  def active_on_equal(this, that)
    if this == that
      "active"
    else
      ""
    end
  end

  def searchable_fields
    [ #Display, #param name
     ['Nick', 'nickname'],
     ['CID', 'uid'],
     [t('activerecord.attributes.user.full_name'), 'name']
    ]
  end

  def image(path)
    file = Rails.root.join('public', 'images') + path
    if File.exists?(file)
      image_tag(image_path(path))
    else
      image_tag(image_path("default.jpg"))
    end
  end
end
