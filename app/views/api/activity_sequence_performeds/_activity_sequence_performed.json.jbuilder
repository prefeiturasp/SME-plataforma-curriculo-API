json.teacher_id activity_sequence_performed.teacher_id
json.activity_sequence_id activity_sequence_performed.activity_sequence_id
json.evaluated activity_sequence_performed.evaluated?
json.activity_sequence do
  activity_sequence = activity_sequence_performed.activity_sequence
  json.id activity_sequence.id
  json.slug activity_sequence.slug
  json.title activity_sequence.title
  json.main_curricular_component do
    json.name activity_sequence.main_curricular_component.name
    json.color activity_sequence.main_curricular_component.color
  end
  json.partial! 'api/images/image', image_param: activity_sequence.image, sizes: %i[icon]
end
