json.extract! @methodology, :id, :slug, :title, :description

json.partial! 'api/images/image', image_param: @methodology.image, sizes: %i[large extra_large]

json.steps @methodology.steps do |step|
  json.extract! step, :title, :description

  json.partial! 'api/images/image', image_param: step.image, sizes: %i[medium]
end

if @methodology.archive.attached?
  json.set! "document" do |json|
    json.size @methodology.archive.byte_size
    json.name @methodology.archive.filename
    json.url  url_for(@methodology.archive)
  end
else
  json.document {}
end

json.content @methodology.content_hash
