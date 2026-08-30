# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImageAttachmentValidator do
  subject(:record) { test_record.new }

  let(:test_record) do
    Class.new do
      include ActiveModel::Validations

      attr_accessor :asset

      validates :asset, image_attachment: true
    end
  end

  let(:attachment_class) do
    Class.new do
      attr_reader :blob

      def initialize(blob, attached:)
        @blob = blob
        @attached = attached
      end

      def attached?
        @attached
      end
    end
  end

  it 'rejects an unattached value' do
    record.asset = attachment_class.new(nil, attached: false)

    aggregate_failures do
      expect(record).not_to be_valid
      expect(record.errors.details[:asset]).to include(a_hash_including(error: :blank))
    end
  end

  it 'accepts an image attachment' do
    record.asset = attachment_with_content_type('image/png')

    expect(record).to be_valid
  end

  it 'rejects a non-image attachment' do
    record.asset = attachment_with_content_type('text/plain')

    aggregate_failures do
      expect(record).not_to be_valid
      expect(record.errors.details[:asset]).to include(a_hash_including(error: :invalid))
    end
  end

  def attachment_with_content_type(content_type)
    blob = instance_double(ActiveStorage::Blob, content_type:)
    attachment_class.new(blob, attached: true)
  end
end
