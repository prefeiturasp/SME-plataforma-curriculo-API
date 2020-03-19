json.email current_user.email
json.username current_user.username
json.name current_user.name

if current_teacher
  json.teacher do
    json.id current_teacher.id
    json.nickname current_teacher.nickname
    json.number_of_classes current_teacher.number_of_classes
    json.number_of_sequences_not_evaluated current_teacher.number_of_sequences_not_evaluated
    json.number_of_components current_teacher.number_of_components
    json.number_of_collections current_teacher.number_of_collections
    json.partial! 'api/images/image', image_param: current_teacher.avatar, sizes: %i[thumb]
  end
end
