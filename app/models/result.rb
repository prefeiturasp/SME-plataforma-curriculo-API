class Result < ApplicationRecord
  include ArchivesConcern

  has_many :links, as: :linkable, dependent: :destroy

  belongs_to :challenge
  belongs_to :teacher

  default_scope { where enabled: true }

  validates :class_name, presence: true

  accepts_nested_attributes_for :links, allow_destroy: true
end
