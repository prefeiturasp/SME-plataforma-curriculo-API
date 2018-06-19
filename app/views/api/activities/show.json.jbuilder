json.sequence @activity.sequence
json.title @activity.title
json.estimated_time @activity.estimated_time
json.image variant_url(@activity.image, :large)

json.content @activity.content

json.activity_sequence do
  json.title @activity.activity_sequence.title
end

json.activity_types @activity.activity_types do |activity_type|
  json.name activity_type.name
end
