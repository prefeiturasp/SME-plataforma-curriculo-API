json.array! @challenges do |challenge|
  json.extract! challenge, :id, :slug, :title, :finish_at
  json.partial! 'api/images/image', image_param: challenge.image, sizes: %i[icon]
end
