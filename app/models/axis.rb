class Axis < ApplicationRecord
  belongs_to :curricular_component
  has_and_belongs_to_many :activity_sequences

  validates :description, presence: true, uniqueness: true

  def self.all_or_with_curricular_component(curricular_component_slug = nil)
    return all unless curricular_component_slug
    joins(:curricular_component).where(
      curricular_components: {
        slug: curricular_component_slug
      }
    )
  end
end
