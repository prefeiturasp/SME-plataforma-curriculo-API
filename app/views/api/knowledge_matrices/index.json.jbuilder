json.array! @knowledge_matrices do |knowledge_matrix|
  json.sequence knowledge_matrix.sequence
  json.title knowledge_matrix.title
  json.know_description knowledge_matrix.know_description
  json.for_description knowledge_matrix.for_description
end
