module Admin
  module LearningObjectivesHelper
    def axes_collection_from_learning_objectives(learning_objective)
      if learning_objective&.curricular_component
        axes = Axis.where(curricular_component_id: learning_objective.curricular_component.id)

        axes.collect do |a|
          [a.description, a.id, { title: a.description }]
        end
      else
        [[t('helpers.select.prompt_curricular_component'), nil, { style: 'display: none;' }]]
      end
    end

    def stage_collection(segment_id)
      stages = Stage.where(
        segment_id: segment_id
      )
      stages.collect do |stage|
        [stage.name, stage.id]
      end
    end
  end
end
