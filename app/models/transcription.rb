# frozen_string_literal: true

class Transcription < Document
  after_save :index_documentable
  after_destroy :index_documentable

  def index_documentable
    documentable.index! if documentable.respond_to?(:index!)
  end
end
