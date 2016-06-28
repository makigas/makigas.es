module ApplicationHelper
  
  # This helper automatically will add "current" class on to a <li> item
  # as required by Bootstrap to show the navbar item using 'current' style.
  def navigation_link text, url
    content_tag(:li, class: current_page?(url) ? 'active' : '') do
      link_to text, url
    end
  end
  
end
