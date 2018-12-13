module ConvertImageConcern
  extend ActiveSupport::Concern

  included do
    has_many_attached :content_images
  end

  def extract_image(base_64)
    return if base_64.blank? || base_64&.include?('/rails/active_storage/blobs/')
    regex = %r{\Adata:([-\w]+\/[-\w\+\.]+)?;base64,(.*)}m
    base_64.match(regex) || []
  end

  def base64_to_url(uri_parts)
    file_properties = base64_to_file(uri_parts)
    attached_image = attach_content_image(
      file_properties[:filename],
      file_properties[:content_type],
      file_properties[:file_path]
    )

    get_image_url(attached_image)
  end

  def base64_to_file(data_uri_parts)
    content_type = data_uri_parts[1]
    base_64_image = data_uri_parts[2]
    extension = Rack::Mime::MIME_TYPES.invert[content_type]
    decode_64 = Base64.decode64(base_64_image)

    file_path = create_temp_file(decode_64, extension)

    { file_path: file_path, filename: File.basename(file_path, '.*'), content_type: content_type, extension: extension }
  end

  def create_temp_file(content, extension)
    return nil if content.blank? || extension.blank?
    timestamp = (Time.now.to_f * 1000).to_i
    file_path = Rails.root.join('tmp', "image#{timestamp}#{extension}")
    File.open(file_path, 'wb') do |file|
      file.write(content)
    end
    file_path
  end

  def attach_content_image(filename, content_type, file_path)
    return nil if filename.blank? || content_type.blank? || file_path.blank?
    content_images.attach(
      io: File.open(file_path),
      filename: filename.to_s,
      content_type: content_type
    )
    File.delete(file_path) if File.exist?(file_path)

    content_images.select { |a| a.filename == filename }.last
  end

  def get_image_url(attached_file)
    return nil if attached_file.blank?
    Rails.application.routes.url_helpers.rails_blob_path(attached_file, only_path: true)
  end
end
