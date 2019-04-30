json.array! @results do |result|
  json.extract! result, :id, :class_name, :created_at
end
