class Link < ApplicationRecord
  belongs_to :linkale, polymorphic: true

  validates :link, presence: true
end
