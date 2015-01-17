module ApplicationHelper

  # Returns true if currently on any of the supplied pages
  def on_pages? *pages
    pages.any?{|p| current_page? p}
  end
end
