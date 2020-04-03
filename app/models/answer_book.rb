class AnswerBook < ApplicationRecord
  belongs_to :curricular_component

  validates :name, presence: true
  validates :cover_image, presence: true
  validates :book_file, presence: true
  validates :year, presence: true
  validates :level, presence: true

  mount_uploader :cover_image, AnswerBookImageUploader
  mount_uploader :book_file, AnswerBookFileUploader

  EDUCATION_LEVEL = {
    'Infantil': :kid,
    'Especial': :special,
    'Fundamental': :basic,
    'EJA': :eja,
    'Orientações': :guide
  }

  SEGMENTOS = {
    kid: 'Infantil',
    special: 'Especial',
    basic: 'Fundamental',
    eja: 'EJA',
    guide: 'Orientações'
  }

  class << self
    def order_by_component_name(level)
      AnswerBook.includes(:curricular_component).where(level: level).order(
        "curricular_components.name asc"
      )
    end
  end
end
