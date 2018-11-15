module ApplicationHelper

  def paginate objects, options = {}
    options.reverse_merge!(theme: 'twitter-bootstrap-3')
    super(objects, options)
  end

  def canonical_url
    parameters = Rack::Utils.parse_nested_query request.query_string
    url_for only_path: false, params: parameters
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

  def dnt_requested
    request.headers.include?('DNT') && request.headers['DNT'].starts_with?('1')
  end
end
