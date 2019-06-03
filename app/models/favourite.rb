class Favourite < ApplicationRecord
  belongs_to :favouritable, polymorphic: true
  belongs_to :teacher

  scope :challenges, -> { where favouritable_type: 'Challenge' }

  def challenge
    self.favouritable_id if self.favouritable_type == 'Challenge'
  end
end
