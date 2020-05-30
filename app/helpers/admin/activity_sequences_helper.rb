module Admin
  module ActivitySequencesHelper
    def learning_objectives_collection(main_curricular_component_id, year_id)
      learning_objectives = LearningObjective.where(
        curricular_component_id: main_curricular_component_id,
        year_id: year_id
      )
      learning_objectives.collect do |lo|
        [lo.code, lo.id, { title: lo.description }]
      end
    end

    def axes_collection(activity_sequence)
      if activity_sequence.learning_objectives.present?
        axes = Axis.where(curricular_component_id: activity_sequence.main_curricular_component.id)

        axes.collect do |a|
          [a.description, a.id, { title: a.description }]
        end
      else
        [[t('helpers.select.prompt_year_and_main_curricular'), nil, { style: 'display: none;' }]]
      end
    end

    def knowledge_matrices_collection
      KnowledgeMatrix.all.order('sequence ASC').collect do |km|
        [km.sequence_and_title, km.id, { title: km.sequence_and_title }]
      end
    end

    def remote_request(type, path, target_tag_id, params = {})
      "$.#{type}('#{path}',
                 {#{params.collect { |p| "#{p[0]}: #{p[1]}" }.join(', ')}},
                 function(data) {$('##{target_tag_id}').html(data);}
       );"
    end
  end
end
