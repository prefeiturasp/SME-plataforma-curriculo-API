json.array! @sustainable_development_goals do |sustainable_development_goal|
  json.sequence sustainable_development_goal.sequence
  json.name sustainable_development_goal.name
  json.icon url_for(sustainable_development_goal.icon)
end
