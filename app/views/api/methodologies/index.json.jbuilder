json.array! @methodologies do |methodology|
  json.extract! methodology, :id, :slug, :title, :description
  json.partial! 'api/images/image', image_param: methodology.image, sizes: %i[large extra_large]
end
