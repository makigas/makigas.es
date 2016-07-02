module ApplicationHelper
  
  # This helper automatically will add "current" class on to a <li> item
  # as required by Bootstrap to show the navbar item using 'current' style.
  def navigation_link text, url
    content_tag(:li, class: current_page?(url) ? 'active' : '') do
      link_to text, url
    end
  end
  
  def running_time sec
    if sec >= 3600
      '%02d:%02d:%02d' % [ sec / 3600, (sec % 3600) / 60, sec % 60]
    else
      '%02d:%02d' % [ sec / 60, sec % 60]
    end
  end
  
  def to_markdown text
    render = Redcarpet::Render::HTML.new()
    markdown = Redcarpet::Markdown.new(render)
    markdown.render(text).html_safe
  end
  
end
