class Rating < ApplicationRecord
  include SequenceConcern

  validates :description, presence: true, uniqueness: true
  validates :enable, presence: true
end
