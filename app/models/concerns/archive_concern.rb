module ArchiveConcern
  extend ActiveSupport::Concern

  included do
    has_one_attached :archive

    before_destroy :purge_archive

    validate :archive_valid?
    validate :archive_valid_size?
  end

  private

    def archive_valid?
      return false unless archive.attached?
      return true if [
        'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        'application/msword', 'application/excel', 'application/pdf',
        'application/powerpoint', 'application/vnd.ms-powerpoint',
        'application/vnd.ms-excel', 'application/msexcel'
      ].include? archive.content_type

      archive.purge_later
      errors.add(:archive, 'needs to be a pdf, doc or ppt')
    end

    def archive_valid_size?
      return false unless archive.attached?
      return true unless archive.byte_size > 4.megabytes
      errors.add(:archive, 'should be less than 4MB')
    end

    def purge_archive
      archive.purge if archive.attached?
    end

end
