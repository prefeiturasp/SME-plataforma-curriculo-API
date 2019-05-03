json.extract! @challenge, :id, :slug, :title, :keywords, :finish_at, :category, :status

json.partial! 'api/images/image', image_param: @challenge.image, sizes: %i[large extra_large]

json.curricular_components @challenge.curricular_components do |curricular_component|
  json.name curricular_component.name
end

json.learning_objectives @challenge.learning_objectives do |learning_objective|
  json.extract! learning_objective, :code, :description

  json.color learning_objective.curricular_component.color
end

json.axes @challenge.axes do |axis|
  json.id          axis.id
  json.description axis.description
end

json.knowledge_matrices @challenge.knowledge_matrices do |knowledge_matrix|
  json.sequence knowledge_matrix.sequence
  json.title    knowledge_matrix.title
end

json.sustainable_development_goals @challenge.sustainable_development_goals do |sds|
  json.name sds.name
  json.icon_url variant_url(sds.icon, :icon)
  json.sub_icon_url url_for(sds.sub_icon)
end

json.content_blocks @challenge.challenge_content_blocks do |challenge_content_block|
  json.type challenge_content_block.content_block.content_type
  json.content challenge_content_block.content_hash if challenge_content_block.content_hash.present?
  if challenge_content_block.images.present?
    json.images challenge_content_block.images do |image|
      json.subtitle image.subtitle
      json.partial! 'api/images/image', image_param: image.file, sizes: %i[medium]
    end
  end
end
