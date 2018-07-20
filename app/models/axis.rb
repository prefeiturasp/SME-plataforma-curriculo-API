class Axis < ApplicationRecord
  belongs_to :curricular_component
  has_and_belongs_to_many :activity_sequences
  include DestroyValidator # has_and_belongs_to_many doesn't support dependent restrict_with_error

  validates :description, presence: true, uniqueness: true
  before_destroy :check_associations

  def self.all_or_with_curricular_component(curricular_component_slug = nil)
    return all unless curricular_component_slug
    joins(:curricular_component).where(
      curricular_components: {
        slug: curricular_component_slug
      }
    )
  end

  private

  def check_associations(associations = %i[activity_sequences curricular_component])
    super(associations)
  end
end
