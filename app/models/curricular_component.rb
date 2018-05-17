class CurricularComponent < ApplicationRecord
  has_many :axes, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  accepts_nested_attributes_for :axes, allow_destroy: true
end
