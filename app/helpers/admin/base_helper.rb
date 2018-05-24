module Admin
  module BaseHelper
    def human_attribute_years
      LearningObjective.years.map { |k, _v| [I18n.t("activerecord.shared_enums.years.#{k}"), k] }
    end
  end
end
