json.id @teacher.id
json.nickname @teacher.nickname
json.user_id @teacher.user_id
json.partial! 'api/images/image', image_param: @teacher.avatar, sizes: %i[thumb extra_thumb]
