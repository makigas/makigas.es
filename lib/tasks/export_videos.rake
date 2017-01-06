namespace :makigas do
  namespace :export do
    desc 'Exports videos as a YAML document.'
    task videos: :environment do
      @playlists = Playlist.all
      @documents = @playlists.map do |playlist|
        {
          "title" => playlist.title,
          "description" => playlist.description,
          "slug" => playlist.slug,
          "youtube_id" => playlist.youtube_id,
          "videos" => playlist.videos.map do |video|
            {
              "title" => video.title,
              "description" => video.description,
              "slug" => video.slug,
              "duration" => video.duration,
              "youtube_id" => video.youtube_id,
              "position" => video.position,
              "created_at" => video.created_at.to_time.iso8601
            }
          end
        }
      end
      puts @documents.to_yaml
    end
  end
end