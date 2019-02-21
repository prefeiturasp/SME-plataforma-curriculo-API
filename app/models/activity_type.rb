class ActivityType < ApplicationRecord
  has_and_belongs_to_many :activities
  include DestroyValidator # has_and_belongs_to_many doesn't support dependent restrict_with_error
  before_destroy :check_associations

  validates :name, presence: true, uniqueness: true

  private

  def check_associations(associations = %i[activities])
    super(associations)
  end
end
