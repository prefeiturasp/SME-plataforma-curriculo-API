class CurricularComponent < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
