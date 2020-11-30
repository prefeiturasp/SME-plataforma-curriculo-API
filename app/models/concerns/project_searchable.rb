module ProjectSearchable
  extend ActiveSupport::Concern

  included do
    searchkick language: 'brazilian',
               word_middle: %i[ title ],
               settings: { blocks: { read_only: false } }
  end

  def search_data
    { title: title }.merge(search_data_to_filters)
  end

  private

  def search_data_to_filters
    {
      old_id: old_id,
      segment_ids: segment_ids,
      stage_ids: stage_ids,
      year_ids: year_ids,
      curricular_component_ids: curricular_component_ids,
      knowledge_matrix_ids: knowledge_matrix_ids,
      student_protagonism_ids: student_protagonism_ids,
      learning_objective_ids: learning_objective_ids,
      regional_education_board_id: regional_education_board_id,
      school_id: school_id,
      axis_ids: axis_ids,
      sustainable_development_goal_ids: sustainable_development_goal_ids
    }
  end
end
