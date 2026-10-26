# frozen_string_literal: true

class TagsController < ApplicationController
  def index
    @tags = Tag.with_attached_icon.select('tags.*', 'LOWER(tags.title) AS lowertitle').order(lowertitle: :asc)
  end
end
