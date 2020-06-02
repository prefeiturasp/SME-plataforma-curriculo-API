module ActivitySequenceSearchable
  extend ActiveSupport::Concern

  included do
    searchkick language: 'brazilian',
               word_middle: %i[main_curricular_component_name
                               title
                               activities_title
                               keywords
                               presentation_text
                               activity_content_block_titles
                               activity_content_block_bodies
                               sustainable_development_goal_names
                               learning_objective_descriptions],
               settings: { blocks: { read_only: false } }
  end

  def search_data
    { main_curricular_component_name: main_curricular_component.name,
      title: title,
      activities_title: activity_titles,
      keywords: keywords,
      presentation_text: presentation_text,
      activity_content_block_titles: activity_content_block_titles,
      activity_content_block_bodies: activity_content_block_bodies,
      sustainable_development_goal_names: sustainable_development_goal_names,
      learning_objective_descriptions: learning_objective_descriptions,
      status: status }.merge(search_data_to_filters)
  end

  private

  def search_data_to_filters
    {
      created_at: created_at,
      main_curricular_component_slug: main_curricular_component.slug,
      axis_ids: axis_ids,
      sustainable_development_goal_ids: sustainable_development_goal_ids,
      stage_id: stage_id,
      segment_id: segment_id,
      year_id: year_id,
      knowledge_matrix_ids: knowledge_matrix_ids,
      learning_objective_ids: learning_objective_ids
    }
  end

  def activity_content_block_titles
    activity_content_blocks.map(&:title).compact
  end

  def activity_content_block_bodies
    activity_content_blocks.map(&:body).compact
  end

  def sustainable_development_goal_names
    sustainable_development_goals.map(&:name)
  end

  def learning_objective_descriptions
    learning_objectives.map(&:description)
  end

  def activity_titles
    activities.map(&:title)
  end
end
