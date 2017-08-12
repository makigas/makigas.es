module Makigas
  class VersionHeader
    def initialize(app, options = {})
      @app = app
      @options = default_options.merge(options)
    end

    def call(env)
      status, headers, body = @app.call(env)
      headers[@options[:header]] = value
      [status, headers, body]
    end

    private

    def default_options
      {
        header: 'X-Powered-By',
        value: 'makigas/:VERSION'
      }
    end

    def value
      @version ||= Makigas::VERSION
      @options[:value].gsub(':VERSION', @version)
    end
  end
end