class Image < ApplicationRecord
  belongs_to :activity_content_block

  has_one_attached :file
end
