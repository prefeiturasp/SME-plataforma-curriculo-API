class Methodology < ApplicationRecord
  include FriendlyId
  include ImageConcern
  include ArchiveConcern

  has_many :steps, dependent: :destroy

  validates :title, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true

  friendly_id :title, use: %i[slugged finders]

  accepts_nested_attributes_for :steps, allow_destroy: true
end
