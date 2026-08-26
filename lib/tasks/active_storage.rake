# frozen_string_literal: true

require Rails.root.join('lib/active_storage/paperclip_migration')

namespace :makigas do
  namespace :active_storage do
    desc 'Migrate Paperclip originals into Active Storage without copying objects'
    task migrate_attachments: :environment do
      dry_run = ENV['DRY_RUN'] == 'true'
      ActiveStorage::PaperclipMigration.migrate!(dry_run: dry_run)
    end

    desc 'Audit Active Storage attachments against Paperclip originals'
    task audit_attachments: :environment do
      ActiveStorage::PaperclipMigration.audit
    end
  end
end
