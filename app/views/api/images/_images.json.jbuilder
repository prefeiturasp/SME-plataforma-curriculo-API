default_size ||= sizes.first

json.images images_param do |image|
  attribute_name = image.name
  json.set! "#{attribute_name}_attributes" do |json|
    json.default_url  variant_url(image, default_size, true)
    json.default_size default_size
    sizes.each do |size|
      json.set! size do
        json.url variant_url(image, size, true)
      end
    end
  end
end
