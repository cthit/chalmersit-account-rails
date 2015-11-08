module ApplicationHelper

  # Returns true if currently on any of the supplied pages
  def on_pages? *pages
    pages.any?{|p| current_page? p}
  end

  def is_me? user
    current_user && current_user.cid == user.uid
  end

  def user_or_me user
    if is_me? user
      me_path
    else
      if policy(user).show?
        user_path(user.uid)
      else
        users_path
      end
    end
  end
end
