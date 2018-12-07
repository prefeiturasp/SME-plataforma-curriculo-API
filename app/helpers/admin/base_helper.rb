module Admin
  module BaseHelper


    def link_to_add_fields(name, f, association, content_type)
      new_object = f.object.class.reflect_on_association(association).klass.new
      partials_path = ContentBlock.partials_path
      fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
        render(partials_path + content_type.to_s.singularize + "_fields", :f => builder)
      end
      fields = "<fieldset class='inputs has_many_fields new_content #{content_type}'><ol>#{fields.to_s}</ol></fieldset>"

      # Rails.logger.debug(">"*80)
      # Rails.logger.debug(fields.inspect)
      # Rails.logger.debug("<"*80)
      
      father = 'asdf asdf'
      link_to "#{ name }", '#', onclick: h("add_fields(this, \"#{association}\", \"#{escape_javascript(fields.to_s)}\", \"#{father}\"); return false;"), data: { id: 'id' }, class: "button #{content_type}"
    end

    def sustainable_development_goals_collection
      SustainableDevelopmentGoal.all.order('sequence ASC').collect do |sds|
        [sds.sequence_and_name, sds.id]
      end
    end

    def human_attribute_years
      LearningObjective.years.map { |k, _v| [I18n.t("activerecord.attributes.enums.years.#{k}"), k] }
    end

    def human_attribute_content_blocks
      ContentBlock.content_types.map { |k,_v| [I18n.t("activerecord.attributes.enums.content_types.#{k}"), k] }
    end

    def human_attribute_environments
      Activity.environments.map { |k, _v| [I18n.t("activerecord.attributes.enums.environments.#{k}"), k] }
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
        [lo.code, lo.id, { title: lo.description }]
      end
    end

    def activity_sequence_preview_path(activity_sequence_slug)
      "#{ENV['HTTP_STAGING_URL']}/sequencia/#{activity_sequence_slug}"
    end

    def activity_preview_path(activity_sequence_slug, activity_slug)
      activity_sequence_preview_path(activity_sequence_slug) << "/atividade/#{activity_slug}"
    end

    def books_toolbar_options
      [['link']]
    end

  end
end
