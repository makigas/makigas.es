# frozen_string_literal: true

require 'rails_helper'
require Rails.root.join('lib/active_storage/paperclip_migration')

RSpec.describe ActiveStorage::PaperclipMigration do
  # rubocop:disable RSpec/MultipleExpectations, Layout/LineLength
  describe '.checksum_and_size' do
    it 'computes the Active Storage Base64 MD5 checksum and byte size' do
      paperclip = instance_double(
        Paperclip::Attachment,
        options: { storage: :filesystem },
        path: Rails.root.join('spec/fixtures/tag.png').to_s
      )

      checksum, byte_size = described_class.checksum_and_size(paperclip)

      expect(checksum).to eq('co/1qORNdM0PI1nvCp7Iig==')
      expect(byte_size).to eq(Rails.root.join('spec/fixtures/tag.png').size)
    end
  end

  describe '.blob_attributes' do
    it 'uses the Paperclip original path as the Active Storage key' do
      paperclip = instance_double(
        Paperclip::Attachment,
        options: { storage: :filesystem },
        path: '/topics/thumbnails/000/001/original/topic.png',
        original_filename: 'topic.png',
        instance_read: nil
      )
      allow(paperclip).to receive(:instance_read).with(:file_size).and_return(Rails.root.join('spec/fixtures/topic.png').size)
      allow(paperclip).to receive(:instance_read).with(:content_type).and_return('image/png')
      allow(paperclip).to receive(:original_filename).and_return('topic.png')
      allow(File).to receive(:file?).and_return(true)
      allow(File).to receive(:open).and_call_original
      allow(paperclip).to receive(:path).with(:original).and_return(Rails.root.join('spec/fixtures/topic.png').to_s)

      attributes = described_class.blob_attributes(paperclip)

      expect(attributes).to include(
        key: 'spec/fixtures/topic.png',
        filename: 'topic.png',
        content_type: 'image/png',
        byte_size: Rails.root.join('spec/fixtures/topic.png').size
      )
    end
  end
  # rubocop:enable RSpec/MultipleExpectations, Layout/LineLength
end
