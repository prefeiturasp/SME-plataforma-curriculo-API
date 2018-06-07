  def self.where_optional_params(params)
    return unless params[:year]
    query = {}
    query[:year] = params[:year] if params[:year]
    
    query.merge!(curricular_components: {
      slug: params[:curricular_component_friendly_id]
    }) if params[:curricular_component_friendly_id]

    query.merge!(curricular_components: {
      axes: {
        id: params[:axis_id],
        year: params[:year]
      }
    }) if params[:axis_id]

    query.merge!(sustainable_development_goals: {
      id: params[:sustainable_development_goal_id]
    }) if params[:sustainable_development_goal_id]

    query.merge!(knowledge_matrices: {
      id: params[:knowledge_matrix_id]
    }) if params[:knowledge_matrix_id]

    query.merge!(learning_objectives: {
      id: params[:learning_objective_id]
    }) if params[:learning_objective_id]

    query.merge!(activities: {
      activity_types: {
        id: params[:activity_type_id]
      }
    }) if params[:activity_type_id]


    all.joins(
      :sustainable_development_goals,
      :knowledge_matrices,
      :learning_objectives,
      :activities,
      activities: :activity_types,
      curricular_components: :axes
    ).where(query)
  end