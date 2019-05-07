json.extract! @result, :id, :class_name, :description, :created_at

json.set! "teacher" do |json|
  json.id       @result.teacher.id
  json.name     @result.teacher.name
  json.user_id  @result.teacher.user_id
  json.partial! 'api/images/image', image_param: @result.teacher.avatar, sizes: %i[thumb extra_thumb]
end

json.links @result.links.collect(&:link)

if @result.archive.attached?
  json.set! "archive" do |json|
    json.name @result.archive.filename
    json.url url_for(@result.archive)
  end
else
  json.archive {}
end
