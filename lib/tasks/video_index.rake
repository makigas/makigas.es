# frozen_string_literal: true

class VideoIndex
  include Rake::DSL

  def initialize
    namespace :makigas do
      desc 'Count the number of items in the index'
      task(count_index: :environment) { count_index }

      desc 'Rebuild the video index'
      task(video_reindex: :environment) { video_reindex }
    end
  end

  private

  def count_index
    puts Video.index.documents['total']
  end

  def video_reindex
    Video.visible.reindex!
  end
end

VideoIndex.new
