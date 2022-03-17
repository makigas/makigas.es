# frozen_string_literal: true

class Transcription < Document
  after_destroy :touch_documentable
  after_save :touch_documentable

  def touch_documentable
    documentable.save
  end
end
