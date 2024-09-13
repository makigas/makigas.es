# frozen_string_literal: true

module Forum
  class Request
    def initialize(*_args, **_kwargs); end

    def cache_key
      nil
    end

    def request(_client)
      raise 'Override the request method'
    end

    def process(_body)
      raise 'Override the process method'
    end
  end
end
