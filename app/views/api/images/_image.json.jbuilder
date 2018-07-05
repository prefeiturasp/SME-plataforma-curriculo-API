attribute_name = image_param.name
default_size ||= sizes.first
json.set! "#{attribute_name}_attributes" do |json|
  json.default_url variant_url(image_param, default_size)
  json.default_size default_size
  sizes.each do |size|
    json.set! size do
      json.url variant_url(image_param, size)
    end
  end
end
