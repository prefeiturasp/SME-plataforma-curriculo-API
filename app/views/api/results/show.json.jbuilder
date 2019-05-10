json.extract! @result, :id, :class_name, :description, :created_at

json.set! "teacher" do |json|
  json.id       @result.teacher.id
  json.name     @result.teacher.name
  json.user_id  @result.teacher.user_id
  json.partial! 'api/images/image', image_param: @result.teacher.avatar, sizes: %i[thumb extra_thumb]
end

json.links @result.links.collect(&:link)

json.partial! 'api/images/images', images_param: @result.images, sizes: %i[medium]

json.documents @result.documents do |archive|
  json.name archive.filename
  json.url  url_for(archive)
end

if @result.next_result
  json.next api_challenge_result_path(challenge_slug: params[:challenge_slug], id: @result.next_result)
end

if @result.prev_result
  json.prev api_challenge_result_path(challenge_slug: params[:challenge_slug], id: @result.prev_result)
end
