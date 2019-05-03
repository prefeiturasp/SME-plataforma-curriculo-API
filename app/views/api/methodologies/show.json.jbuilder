json.extract! @methodology, :id, :slug, :title, :description

json.partial! 'api/images/image', image_param: @methodology.image, sizes: %i[large extra_large]

json.content_blocks @challenge.contents do |content_block|
  json.type    content_block.content_block.content_type
  json.content content_block.content_hash if content_block.content_hash.present?

  if content_block.images.present?
    json.images content_block.images do |image|
      json.subtitle image.subtitle
      json.partial! 'api/images/image', image_param: image.file, sizes: %i[medium]
    end
  end
end
