module ApplicationHelper
  def variant_url(image, size)
    return unless image.attached?
    url_for(image.variant(resize: image_sizes[size]))
  end

  def image_sizes
    {
      icon: '60x60',
      small: '256x128',
      medium: '256x160',
      large: '1110x568'
    }
  end
end
