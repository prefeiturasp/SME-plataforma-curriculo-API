json.sequence @activity.sequence
json.title @activity.title
json.estimated_time @activity.estimated_time
json.environment @activity.environment
json.image variant_url(@activity.image, :large)
json.next_activity @activity.next_activity.try(:slug)
json.last_activity @activity.last_activity.try(:slug)

json.content @activity.content

json.activity_sequence do
  json.slug @activity.activity_sequence.slug
  json.title @activity.activity_sequence.title
  json.year @activity.activity_sequence.year
  json.main_curricular_component do
    json.name @activity.activity_sequence.main_curricular_component.name
    json.color @activity.activity_sequence.main_curricular_component.color
  end
end

json.activity_types @activity.activity_types do |activity_type|
  json.name activity_type.name
end
