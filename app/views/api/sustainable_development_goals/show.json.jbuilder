json.id @sustainable_development_goal.id
json.sequence @sustainable_development_goal.sequence
json.name @sustainable_development_goal.name
json.description @sustainable_development_goal.description
json.color @sustainable_development_goal.color
json.icon variant_url(@sustainable_development_goal.icon, :icon)
json.sub_icon variant_url(@sustainable_development_goal.sub_icon, :icon)

json.goals @sustainable_development_goal.goals do |sdg|
  json.description sdg.description
end
