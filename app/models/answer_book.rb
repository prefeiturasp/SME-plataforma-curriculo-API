class AnswerBook < ApplicationRecord
  belongs_to :curricular_component

  validates :name, presence: true
  validates :cover_image, presence: true
  validates :book_file, presence: true
  validates :year, presence: true
  validates :level, presence: true

  mount_uploader :cover_image, AnswerBookFilesUploader
  mount_uploader :book_file, AnswerBookFilesUploader

  EDUCATION_LEVEL = {
    'Infantil': :kid,
    'Especial': :special,
    'Fundamental': :basic,
    'EJA': :eja,
    'Orientações': :guide
  }

  class << self
    def order_by_component_name(level)
      AnswerBook.includes(:curricular_component).where(level: level).order(
        "curricular_components.name asc"
      )
    end
  end
end
