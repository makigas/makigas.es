# frozen_string_literal: true

class FrontController < ApplicationController
  def index
    @tags = Tag.select('*',
                       '(SELECT sum(views_recent) FROM videos WHERE videos.tags @> ARRAY[tags.slug]::varchar[]) as pop')
               .order(pop: :desc)
               .limit(8)
  end
end
