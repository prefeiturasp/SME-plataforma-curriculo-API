class AnswerBook < ApplicationRecord
  belongs_to :curricular_component
  belongs_to :stage
  belongs_to :segment

  validates :name, presence: true
  validates :cover_image, presence: true
  validates :book_file, presence: true
  validates :year, presence: true

  mount_uploader :cover_image, AnswerBookImageUploader
  mount_uploader :book_file, AnswerBookFileUploader

  class << self
    def order_by_component_name(segment_name)
      segment = Segment.find_by(name: segment_name)
      if segment
        AnswerBook.includes(:curricular_component).where(segment_id: segment.id).order(
          "curricular_components.name asc"
        )
      else
        []
      end
    end
  end
end
