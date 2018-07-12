class Axis < ApplicationRecord
  include YearsEnum
  belongs_to :curricular_component
  has_and_belongs_to_many :activity_sequences

  validates :description, presence: true, uniqueness: true
  validates :year, presence: true

  def year_and_description
    "#{year_name} - #{curricular_component.name} - #{description}"
  end

  def year_name
    I18n.t("activerecord.attributes.enums.years.#{year}")
  end

  def self.all_or_with_year(year = nil)
    return all unless year
    where(year: year)
  end

  def self.all_or_with_curricular_component(curricular_component_slug = nil)
    return all unless curricular_component_slug
    joins(:curricular_component).where(
      curricular_components: {
        slug: curricular_component_slug
      }
    )
  end
end
