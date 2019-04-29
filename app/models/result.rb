class Result < ApplicationRecord
  has_many :links, as: :linkable, dependent: :destroy
  belongs_to :challenge, dependent: :destroy
  belongs_to :teacher, dependent: :destroy

  default_scope { where enabled: true }

  accepts_nested_attributes_for :links, allow_destroy: true
end
