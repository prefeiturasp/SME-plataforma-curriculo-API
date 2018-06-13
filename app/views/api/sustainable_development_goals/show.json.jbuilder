json.sequence @sustainable_development_goal.sequence
json.name @sustainable_development_goal.name
json.description @sustainable_development_goal.description
json.icon url_for(@sustainable_development_goal.icon)

json.goals @sustainable_development_goal.goals do |sdg|
  json.description sdg.description
end
