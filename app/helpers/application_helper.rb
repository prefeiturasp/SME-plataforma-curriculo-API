module ApplicationHelper
  def variant_url(image, size, attached = false)
    url_for(
      image.content_type == "image/svg+xml" ? image : image.variant(resize: image_sizes[size])
    ) if attached || image.attached?
  end

  def image_sizes
    {
      icon:        '144x144',
      small:       '256x128',
      extra_small: '512x256',
      thumb:       '256x160',
      extra_thumb: '512x320',
      medium:      '730x518',
      large:       '1110x568',
      extra_large: '2220x1136'
    }
  end

#  def protect_against_forgery?
#    false
#  end
end
