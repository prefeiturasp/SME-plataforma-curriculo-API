module Admin
  module BaseHelper
    def sustainable_development_goals_collection
      SustainableDevelopmentGoal.all.order('sequence ASC').collect do |sds|
        [sds.sequence_and_name, sds.id]
      end
    end

    def human_attribute_years
      LearningObjective.years.map { |k, _v| [I18n.t("activerecord.attributes.enums.years.#{k}"), k] }
    end

    def human_attribute_environments
      Activity.environments.map { |k,_v| [I18n.t("activerecord.attributes.enums.environments.#{k}"), k] }
    end

    def human_attribute_roadmap_statuses
      Roadmap.statuses.map { |k, _v| [I18n.t("activerecord.attributes.roadmap.statuses.#{k}"), k] }
    end

    def sequence_options(_model)
      options = _model.order(:sequence).pluck(:sequence)
      options << (options[-1].nil? ? 1 : (options[-1] + 1))
    end

    def activity_sequence_options(activity)
      activity_sequence = activity.activity_sequence
      options = activity_sequence.activities.order(:sequence).pluck(:sequence)
      options << (options[-1].nil? ? 1 : (options[-1] + 1))
    end


    def learning_objectives_activity_collection(activity)
      activity_sequence = activity.activity_sequence
      learning_objectives = activity_sequence.learning_objectives
      learning_objectives.collect do |lo|
        [lo.code_and_description, lo.id]
      end
    end
  end
end
