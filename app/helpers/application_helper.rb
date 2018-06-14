module ApplicationHelper
  def variant_url(image, size)
    url_for(image.variant(resize: image_sizes[size]))
  end

  def image_sizes
    {
      icon: '60x60',
      medium: '256x128',
      large: '1110x568'
    }
  end
end
