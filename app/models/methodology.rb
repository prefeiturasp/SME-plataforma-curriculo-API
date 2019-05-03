class Methodology < ApplicationRecord
  include FriendlyId
  include ImageConcern

  has_many :contents, as: :contentable, dependent: :destroy

  validates :title, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true

  friendly_id :title, use: %i[slugged finders]

  accepts_nested_attributes_for :contents, allow_destroy: true
end
