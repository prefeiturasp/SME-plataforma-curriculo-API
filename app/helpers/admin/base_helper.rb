module Admin
  module BaseHelper
    def sustainable_development_goals_collection
      SustainableDevelopmentGoal.all.order('sequence ASC').collect do |sds|
        [sds.sequence_and_name, sds.id]
      end
    end

    def human_attribute_environments
      Activity.environments.map { |k, _v| [I18n.t("activerecord.attributes.enums.environments.#{k}"), k] }
    end

    def human_attribute_roadmap_statuses
      Roadmap.statuses.map { |k, _v| [I18n.t("activerecord.attributes.roadmap.statuses.#{k}"), k] }
    end

    def sequence_options(_model)
      return [1] if (_model.all.count == 0)
      options = (1.._model.all.count).map { |sequence| sequence }
    end

    def activity_sequence_options(activity)
      activity_sequence = activity.activity_sequence
      options = activity_sequence.activities.order(:sequence).pluck(:sequence)
      options << (options[-1].nil? ? 1 : (options[-1] + 1))
    end

    def public_consultation_options(survey_form)
      public_consultation = survey_form.public_consultation
      options = public_consultation.survey_forms.order(:sequence).pluck(:sequence)
      options << (options[-1].nil? ? 1 : (options[-1] + 1))
    end

    def learning_objectives_activity_collection(activity)
      activity_sequence = activity.activity_sequence
      learning_objectives = activity_sequence.learning_objectives
      learning_objectives.collect do |lo|
        [lo.code, lo.id, { title: lo.description }]
      end
    end

    def learning_objectives_challenge_collection challenge
#      learning_objectives = challenge.learning_objectives
      LearningObjective.all.collect do |lo|
        [lo.code, lo.id, { title: lo.description }]
      end
    end

    def activity_sequence_preview_path(activity_sequence_slug)
      "#{ENV['HTTP_STAGING_URL']}/sequencia/#{activity_sequence_slug}"
    end

    def activity_preview_path(activity_sequence_slug, activity_slug)
      activity_sequence_preview_path(activity_sequence_slug) << "/atividade/#{activity_slug}"
    end

    def challenge_preview_path challenge_slug
      "#{ENV['HTTP_STAGING_URL']}/desafio/#{challenge_slug}"
      #activity_sequence_preview_path(activity_sequence_slug) << "/atividade/#{activity_slug}"
    end

    def books_toolbar_options
      [['link']]
    end

    def image_container(image, size)
      link_to delete_image_attachment_admin_activity_sequences_url(id: image.id),
              method: :delete,
              class: 'remove-image-link',
              data: { confirm: 'Deseja remover esta imagem?' } do
        content_tag(:span, 'Clique para remover', class: 'remove-image-message') + image_tag(variant_url(image, size))
      end
    end
  end
end
