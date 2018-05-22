module Admin
  module LearningObjectivesHelper
    def human_attribute_years
      LearningObjective.years.map { |k, _v| [I18n.t("activerecord.attributes.learning_objective.years.#{k}"), k] }
    end
  end
end
