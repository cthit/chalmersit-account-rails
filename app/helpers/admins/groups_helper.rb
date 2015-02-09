module Admins::GroupsHelper
  def table_row klass, attribute
    values = klass.send(attribute, true)

    if values.size == 1
      return content_tag :tr do
        content_tag(:td, attribute) +
        content_tag(:td, values.first)
      end
    else
      return content_tag :tr do
        content_tag(:td, attribute, rowspan: values.size) +
        content_tag(:td, values.first ) +
        values[1..-1].map{|v| content_tag :tr, content_tag(:td, v)}.join.html_safe
      end
    end
  end
end
