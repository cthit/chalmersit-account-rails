module GroupsHelper
  def print_if_present tag, str
    if str.nil?
      return
    else
      content_tag(tag, str)
    end
  end
end
