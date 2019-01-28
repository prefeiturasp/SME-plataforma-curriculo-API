json.array! @activity_sequence_ratings do |activity_sequence_rating|
  json.rating_id activity_sequence_rating.rating_id
  json.description activity_sequence_rating.rating.description
  json.score activity_sequence_rating.score
end
