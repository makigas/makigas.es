module Makigas
  class RevisionHeader

    def initialize(app, options = {})
      @app = app
      @options = default_options.merge(options)
    end

    def call(env)
      request, headers, response = @app.call(env)
      headers[@options[:header]] = value unless revision.nil?
      [request, headers, response]
    end

    private

    def default_options
      {
        header: 'X-VCS-Revision',
        value: ':REVISION',
        file: 'REVISION'
      }
    end

    def revision
      if File.exists?(@options[:file])
        @revision ||= File.read(@options[:file]).strip
        @revision
      else
        nil
      end
    end

    def value
      @options[:value].gsub(':REVISION', revision)
    end

  end
end