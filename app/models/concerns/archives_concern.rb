module ArchivesConcern
  extend ActiveSupport::Concern

  included do
    has_many_attached :archives

    before_destroy :purge_archives

    validate :archive_valid?
  end

  private

    def purge_archives
      archives.each do |archive|
        archive.purge
      end if archives.attached?
    end

    def archive_valid?
      message = ''
      if archives.attached?
        archives.each do |archive|
          if ![
            'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
            'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
            'application/msword', 'application/excel', 'application/pdf',
            'application/powerpoint', 'application/vnd.ms-powerpoint',
            'application/vnd.ms-excel', 'application/msexcel',
            'image/png', 'image/jpeg', 'image/jpg'
          ].include? archive.content_type
            archive.purge_later
            message = 'needs to be a pdf, doc, ppt or image'
          elsif archive.byte_size > 4.megabytes
            archive.purge_later
            message = 'should be less than 4MB'
          end
        end
      end

      errors.add(:archives, message) unless message.blank?
    end

end
