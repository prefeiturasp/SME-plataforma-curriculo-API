json.email current_user.email

teacher = current_user&.teacher
if teacher
  json.teacher do
    json.id teacher.id
    json.nickname teacher.nickname
    json.partial! 'api/images/image', image_param: teacher.avatar, sizes: %i[thumb]
  end
end
