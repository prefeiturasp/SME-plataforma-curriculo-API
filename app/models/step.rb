class Step < ApplicationRecord
  include ImageConcern

  belongs_to :methodology

  validates :title, presence: true
  validates :description, presence: true
end
