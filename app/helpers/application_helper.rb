module ApplicationHelper
  def paginate(objects, options = {})
    options.reverse_merge!(theme: 'twitter-bootstrap-3')
    super(objects, options)
  end

  def canonical_url
    parameters = Rack::Utils.parse_nested_query request.query_string
    url_for only_path: false, params: parameters
  end

  def running_time(sec, options = {})
    times = if sec >= 3600 || (!options[:full].nil? && options[:full] == true)
              [sec / 3600, (sec % 3600) / 60, sec % 60]
            else
              [sec / 60, sec % 60]
            end
    format_as_timestamp(times)
  end

  def extract_time(sec)
    if (match = sec.match(/^([0-9]+):([0-5][0-9]):([0-5][0-9])$/))
      hours, minutes, seconds = match.captures
      hours.to_i * 3600 + minutes.to_i * 60 + seconds.to_i
    elsif (match = sec.match(/^([0-5]?[0-9]):([0-5][0-9])$/))
      minutes, seconds = match.captures
      minutes.to_i * 60 + seconds.to_i
    elsif (match = sec.match(/^([0-5]?[0-9])$/))
      seconds = match.captures[0]
      seconds.to_i
    end
  end

  def to_markdown(text)
    render = Redcarpet::Render::HTML.new
    markdown = Redcarpet::Markdown.new(render)
    markdown.render(text)
  end

  def dnt_requested
    request.headers.include?('DNT') && request.headers['DNT'].starts_with?('1')
  end

  private

  def format_as_timestamp(value_list)
    first, *remain = value_list
    first.to_s + ':' + remain.map { |val| val.to_s.rjust(2, '0') }.join(':')
  end
end
