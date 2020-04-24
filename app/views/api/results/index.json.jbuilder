json.array! @results do |result|
  json.extract! result, :id, :class_name, :description, :created_at

  json.has_archive result.archives.attached?

  json.set! "teacher" do |json|
    json.id       result.teacher.id
    json.name     result.teacher.name
    json.user_id  result.teacher.user_id
    json.partial! 'api/images/image', image_param: result.teacher.avatar, sizes: %i[thumb extra_thumb]
  end
end
