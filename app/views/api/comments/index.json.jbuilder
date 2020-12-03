json.array! @comments do |comment|
  json.teacher_id comment.teacher_id
  json.project_id comment.project_id
  json.id comment.id
  json.body comment.body
end
