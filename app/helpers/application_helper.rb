module ApplicationHelper

  # This helper automatically will add "current" class on to a <li> item
  # as required by Bootstrap to show the navbar item using 'current' style.
  def navigation_link text, url
    content_tag(:li, class: "nav-item #{current_page?(url) ? 'active' : ''}") do
      link_to text, url, class: 'nav-link'
    end
  end

  def running_time sec, options = {}
    if sec >= 3600 || (!options[:full].nil? && options[:full] == true)
      '%d:%02d:%02d' % [ sec / 3600, (sec % 3600) / 60, sec % 60]
    else
      '%d:%02d' % [ sec / 60, sec % 60]
    end
  end

  def extract_time sec
    if match = sec.match(/^([0-9]+):([0-5][0-9]):([0-5][0-9])$/)
      hours, minutes, seconds = match.captures
      hours.to_i * 3600 + minutes.to_i * 60 + seconds.to_i
    elsif match = sec.match(/^([0-5]?[0-9]):([0-5][0-9])$/)
      minutes, seconds = match.captures
      minutes.to_i * 60 + seconds.to_i
    elsif match = sec.match(/^([0-5]?[0-9])$/)
      seconds = match.captures[0]
      seconds.to_i
    else
      nil
    end
  end

  def to_markdown text
    render = Redcarpet::Render::HTML.new()
    markdown = Redcarpet::Markdown.new(render)
    markdown.render(text).html_safe
  end
  
  def horizontal_form_for(resource, options = {}, &block)
    options[:html] = { class: 'form-horizontal' }
    options[:wrapper] = :horizontal_form
    options[:wrapper_mappings] = {
      check_boxes: :horizontal_radio_and_checkboxes,
      radio_buttons: :horizontal_radio_and_checkboxes,
      file: :horizontal_file_input,
      boolean: :horizontal_boolean
    }
    simple_form_for(resource, options, &block)
  end

end
