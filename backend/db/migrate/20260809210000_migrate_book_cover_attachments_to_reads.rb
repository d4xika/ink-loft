class MigrateBookCoverAttachmentsToReads < ActiveRecord::Migration[8.1]
  def up
    execute <<~SQL.squish
      UPDATE active_storage_attachments AS old_attachment
      SET record_type = 'Read'
      WHERE old_attachment.record_type = 'Book'
        AND old_attachment.name = 'cover'
        AND NOT EXISTS (
          SELECT 1
          FROM active_storage_attachments AS current_attachment
          WHERE current_attachment.record_type = 'Read'
            AND current_attachment.record_id = old_attachment.record_id
            AND current_attachment.name = old_attachment.name
        )
    SQL
  end

  def down
    execute <<~SQL.squish
      UPDATE active_storage_attachments AS current_attachment
      SET record_type = 'Book'
      WHERE current_attachment.record_type = 'Read'
        AND current_attachment.name = 'cover'
        AND NOT EXISTS (
          SELECT 1
          FROM active_storage_attachments AS old_attachment
          WHERE old_attachment.record_type = 'Book'
            AND old_attachment.record_id = current_attachment.record_id
            AND old_attachment.name = current_attachment.name
        )
    SQL
  end
end
