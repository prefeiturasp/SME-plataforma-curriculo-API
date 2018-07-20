class Axis < ApplicationRecord
  belongs_to :curricular_component
  has_and_belongs_to_many :activity_sequences

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
    def check_associations
      %i[activity_sequences curricular_component].each do |association|
        a = send(association)
        if a.present?
          klass = nil
          message = 'activerecord.errors.messages.restrict_dependent_destroy.'
          if a.try(:last)
            klass = a.try(:last).try(:class)
            message += 'has_many'
          else
            klass = a.class
            message += 'has_one'
          end
          errors.add(association, I18n.t(message, record: klass.model_name.human))
          throw(:abort)
        end
      end
    end
end
