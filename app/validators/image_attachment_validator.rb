# frozen_string_literal: true

class ImageAttachmentValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, attachment)
    return record.errors.add(attribute, :blank) unless attachment.attached?

    record.errors.add(attribute, :invalid) unless attachment.blob.content_type.to_s.start_with?('image/')
  end
end
