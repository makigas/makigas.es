import 'yaml'

module Makigas
  class VideoImport
    def initialize(schema)
      @schema = YAML.load(File.read(schema))
      @schema.map do |playlist|
        pl = Playlist.create!(title: playlist['title'],
                              description: playlist['description'], slug: playlist['slug'],
                              youtube_id: playlist['youtube_id'])
        playlist['videos'].each do |video|
          Video.create!(playlist: pl, title: video['title'],
                        description: video['description'], slug: video['slug'],
                        youtube_id: video['youtube_id'], duration: video['duration'],
                        position: video['position'],
                        created_at: Time.parse(video['created_at']).utc)
        end
      end
    end
  end
end
