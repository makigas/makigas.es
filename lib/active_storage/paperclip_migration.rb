# frozen_string_literal: true

require 'base64'
require 'digest'

module ActiveStorage
  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Metrics/ModuleLength
  module PaperclipMigration
    AttachmentSpec = Data.define(:model_name, :name)

    ATTACHMENTS = [
      AttachmentSpec.new('Topic', :thumbnail),
      AttachmentSpec.new('Playlist', :thumbnail),
      AttachmentSpec.new('Playlist', :card),
      AttachmentSpec.new('Tag', :icon)
    ].freeze

    module_function

    def migrate!(dry_run: false, output: $stdout)
      summary = Summary.new(output)

      each_paperclip_attachment do |record, name, paperclip|
        migrate_attachment!(record, name, paperclip, dry_run: dry_run)
        summary.success(record, name, dry_run: dry_run)
      rescue StandardError => e
        summary.failure(record, name, e)
      end

      summary.finish
    end

    def audit(output: $stdout)
      summary = Summary.new(output)

      each_paperclip_attachment do |record, name, paperclip|
        audit_attachment!(record, name, paperclip)
        summary.success(record, name, dry_run: true)
      rescue StandardError => e
        summary.failure(record, name, e)
      end

      summary.finish
    end

    def each_paperclip_attachment
      ATTACHMENTS.each do |spec|
        spec.model_name.constantize.find_each do |record|
          paperclip = record.public_send(spec.name)
          next if paperclip.original_filename.blank?

          yield record, spec.name, paperclip
        end
      end
    end

    def migrate_attachment!(record, name, paperclip, dry_run:)
      attributes = blob_attributes(paperclip)
      existing_blob = ActiveStorage::Blob.find_by(key: attributes[:key])
      existing_attachment = ActiveStorage::Attachment.find_by(
        record_type: record.class.base_class.name,
        record_id: record.id,
        name: name
      )

      validate_existing!(existing_blob, existing_attachment, record, name, attributes)
      return if existing_blob && existing_attachment
      return if dry_run

      ActiveRecord::Base.transaction do
        blob = existing_blob || ActiveStorage::Blob.create!(attributes)
        ActiveStorage::Attachment.create!(
          record_type: record.class.base_class.name,
          record_id: record.id,
          name: name,
          blob: blob
        )
      end
    end

    def audit_attachment!(record, name, paperclip)
      attributes = blob_attributes(paperclip)
      blob = ActiveStorage::Blob.find_by(key: attributes[:key])
      attachment = ActiveStorage::Attachment.find_by(
        record_type: record.class.base_class.name,
        record_id: record.id,
        name: name
      )

      raise "missing Active Storage blob for #{record.class}##{record.id}.#{name}" unless blob
      raise "missing Active Storage attachment for #{record.class}##{record.id}.#{name}" unless attachment
      raise 'attachment points to the wrong blob' unless attachment.blob_id == blob.id

      attributes.each do |key, value|
        raise "#{key} mismatch for #{record.class}##{record.id}.#{name}" unless blob.public_send(key) == value
      end
    end

    def blob_attributes(paperclip)
      key = paperclip_key(paperclip)
      raise "missing Paperclip original at #{key}" unless paperclip_original_exists?(paperclip)

      checksum, byte_size = checksum_and_size(paperclip)
      expected_size = paperclip.instance_read(:file_size).to_i
      unless byte_size == expected_size
        raise "byte size mismatch for #{key}: expected #{expected_size}, got #{byte_size}"
      end

      {
        key: key,
        filename: paperclip.original_filename,
        content_type: paperclip.instance_read(:content_type),
        byte_size: byte_size,
        checksum: checksum,
        service_name: ActiveStorage::Blob.service.name.to_s
      }
    end

    def validate_existing!(blob, attachment, record, name, attributes)
      if blob && attributes.any? { |key, value| blob.public_send(key) != value }
        raise "conflicting Active Storage blob for #{record.class}##{record.id}.#{name}"
      end

      return unless attachment && (!blob || attachment.blob_id != blob.id)

      raise "conflicting Active Storage attachment for #{record.class}##{record.id}.#{name}"
    end

    def paperclip_key(paperclip)
      path = Pathname.new(paperclip.path(:original).to_s)
      return path.relative_path_from(Rails.root).to_s if path.absolute? && path.to_s.start_with?(Rails.root.to_s)

      path.to_s.sub(%r{\A/}, '')
    end

    def paperclip_original_exists?(paperclip)
      if paperclip_s3?(paperclip)
        paperclip.s3_object(:original).exists?
      else
        File.file?(paperclip.path(:original))
      end
    end

    def checksum_and_size(paperclip)
      digest = Digest::MD5.new
      size = 0

      with_original_io(paperclip) do |io|
        while (chunk = io.read(1024 * 1024))
          digest.update(chunk)
          size += chunk.bytesize
        end
      end

      [Base64.strict_encode64(digest.digest), size]
    end

    def with_original_io(paperclip, &)
      if paperclip_s3?(paperclip)
        yield paperclip.s3_object(:original).get.body
      else
        File.open(paperclip.path(:original), 'rb', &)
      end
    end

    def paperclip_s3?(paperclip)
      paperclip.respond_to?(:s3_object) && paperclip.options[:storage]&.to_sym == :s3
    end

    class Summary
      def initialize(output)
        @output = output
        @processed = 0
        @failed = 0
      end

      def success(record, name, dry_run:)
        @processed += 1
        action = dry_run ? 'checked' : 'migrated'
        @output.puts "#{action} #{record.class}##{record.id}.#{name}"
      end

      def failure(record, name, error)
        @failed += 1
        @output.puts "ERROR #{record.class}##{record.id}.#{name}: #{error.message}"
      end

      def finish
        @output.puts "Processed: #{@processed}; failed: #{@failed}"
        raise 'Active Storage attachment migration failed' if @failed.positive?
      end
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength, Metrics/ModuleLength
end
