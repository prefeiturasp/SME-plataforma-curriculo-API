class Methodology < ApplicationRecord
  include FriendlyId
  include ImageConcern
  include ArchiveConcern

  validates :title, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true

  friendly_id :title, use: %i[slugged finders]
end
