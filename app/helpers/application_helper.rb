module ApplicationHelper

  # Returns true if currently on any of the supplied pages
  def on_pages? *pages
    pages.any?{|p| current_page? p}
  end

  def is_me? user
    current_user && current_user == user.db_user
  end

  def user_or_me user
    if is_me? user
      me_path
    else
      user_path(user.uid)
    end
  end
end
