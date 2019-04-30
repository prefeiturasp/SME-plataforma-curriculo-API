json.extract! @result, :id, :class_name, :description, :created_at

json.links @result.links.collect(&:link)

json.set! "archive" do |json|
  json.name @result.archive.filename
  json.url url_for(@result.archive)
end
