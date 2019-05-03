json.array! @methodologies do |methodology|
  json.extract! methodology, :id, :slug, :title
  json.partial! 'api/images/image', image_param: methodology.image, sizes: %i[icon]
end
