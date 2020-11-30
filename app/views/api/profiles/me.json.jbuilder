json.email current_user.email
json.username current_user.username
json.name current_user.name

if current_user.teacher
  json.teacher do
    json.id current_user.teacher.id
    json.name current_user.teacher.name
    json.nickname current_user.teacher.nickname
    json.number_of_classes current_user.teacher.number_of_classes
    json.number_of_sequences_not_evaluated current_user.teacher.number_of_sequences_not_evaluated
    json.number_of_components current_user.teacher.number_of_components
    json.number_of_collections current_user.teacher.number_of_collections
    json.partial! 'api/images/image', image_param: current_user.teacher.avatar, sizes: %i[thumb]
  end
end
