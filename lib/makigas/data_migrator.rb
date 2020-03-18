require 'json'

# This class is used to import bulk videos and playlists into the system.
#
# Old makigas website is based on WordPress, which uses a different schema
# for storing data. This class doesn't import WordPress export files. An export
# file must be separately processed into a migration scheme that is compatible
# with this format.
#
# The data migrator will accept a JSON file containing information for videos.
# The schema is based on a root that is an array of JSON objects for topics.
# Each topic is a JSON object that has many fields shared with the Topic model
# in this webapp: title, description, created_at and playlists.
#
# Playlists is an array of JSON objects that represent a playlist, again
# sharing many fields with the Playlist model: title, description, youtube_id,
# created_at and videos.
#
# Videos is another array of JSON objects that represents a video and uses
# the same fields as the Video model: title, description, youtube_id,
# natural_duration, position and created_at.
#
# There should be also a folder with thumbnails for YouTube videos. Each file
# should have the name "#{v}.jpg" where v is the YouTube ID for a video.
# The migrator will paste the thumbnail file as the photo for the video.
# The migrator will paste the first video photo as the photo for the playlist.
# The migrator will paste the first playlist photo as the photo for the topic.
class Makigas::DataMigrator
  def initialize schema, thumbnails
    raise 'Not a thumbnails folder' unless File::directory?(thumbnails)

    @schema = JSON.parse!(File.read(schema))
    @thumbnails = thumbnails
  end

  def load!
    @schema.each do |topic|
      load_topic!(topic)
    end
  end

  private

  # This method will load into the database the contents for a topic,
  # including playlists associated with that topic, including videos
  # associated with that playlist.
  def load_topic! t
    # Thumbnail is taken from the first episode of the first playlist.
    thumbnail = t["playlists"][0]["videos"][0]["youtube_id"]

    # Create the topic.
    topic = Topic.new
    topic.title = t["title"]
    topic.description = t["description"]
    topic.created_at = t["created_at"]
    File.open(File.join(@thumbnails, "#{thumbnail}.jpg")) do |f|
      topic.photo = f
    end
    topic.save

    # Add the playlists for this topic.
    t["playlists"].each { |p| load_playlist! p, topic }
  end

  # This method will load into the database the contents for a playlist
  # +p+ and associate it as a playlist part of the Topic object +topic+.
  def load_playlist! p, topic
    # Thumbnail is taken from the first episode of the playlist
    thumbnail = p["videos"][0]["youtube_id"]

    # Create the playlist
    playlist = Playlist.new
    playlist.title = p["title"]
    playlist.description = p["description"]
    playlist.created_at = p["created_at"]
    playlist.youtube_id = p["youtube_id"]
    playlist.topic = topic
    File.open(File.join(@thumbnails, "#{thumbnail}.jpg")) do |f|
      playlist.photo = f
    end
    playlist.save

    # Add the videos for this playlist
    p["videos"].each { |v| load_video! v, playlist }
  end

  # This method will load into the database the contents for a video +v+
  # and associate it as a video part of the Playlist object +playlist+.
  def load_video! v, playlist
    video = Video.new
    video.title = v["title"]
    video.description = v["description"].split('\n')[0]
    video.youtube_id = v["youtube_id"]
    video.natural_duration = v["natural_duration"]
    video.position = v["position"]
    video.created_at = v["created_at"]
    video.playlist = playlist
    File.open(File.join(@thumbnails, "#{v["youtube_id"]}.jpg")) do |f|
      video.thumbnail = f
    end
    video.save
  end
end
