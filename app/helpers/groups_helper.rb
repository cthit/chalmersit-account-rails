module GroupsHelper
  def dd_link icon, text, link
    content_tag :dt, fa_icon(icon, text: text) + (content_tag :dd, (link_to link, link))
  end

  def dd_homepages homepages
    homepages.each do |www|
      if www.include? 'facebook.com'
        concat dd_link 'facebook', 'facebook', www
      elsif www.include? 'twitter.com'
        concat dd_link 'twitter', 'Twitter', www
      elsif www.include? 'github.com'
        concat dd_link 'github', 'GitHub', www
      else
        concat dd_link 'external-link', t('homepage', count: 1), www
      end
    end
    nil
  end
end
