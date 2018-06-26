class Activity < ApplicationRecord
  include FriendlyId
  include ImageConcern
  include SequenceConcern

  belongs_to :activity_sequence
  has_and_belongs_to_many :activity_types

  validates :title, presence: true, uniqueness: true
  validates :estimated_time, presence: true
  validates :content, presence: true
  validates :slug, presence: true

  enum environment: { interior: 0, exterior: 1 }

  has_many_attached :content_images

  friendly_id :title, use: %i[slugged finders]

  before_save :change_format_content_images

  def next_activity
    Activity.find_by(sequence: next_sequence)
  end

  def last_activity
    Activity.find_by(sequence: last_sequence) if last_sequence
  end

  def next_sequence
    sequence + 1
  end

  def last_sequence
    return nil if sequence <= 1
    sequence - 1
  end

  def should_generate_new_friendly_id?
    title_changed? || super
  end

  def change_format_content_images
    return nil if content.blank?
    content_json = JSON.parse(content)
    content_json['ops'].each do |c|
      base_64 = c['insert']['image']
      next if base_64.blank? || base_64&.include?('/rails/active_storage/blobs/')
      c['insert']['image'] = base64_to_url(base_64)
    end

    self.content = content_json.to_json
  end

  def base64_to_url(base_64)
    file_properties = base64_to_file(base_64)
    attached_image = attach_content_image(
      file_properties[:filename],
      file_properties[:content_type],
      file_properties[:file_path]
    )

    get_image_url(attached_image)
  end

  def base64_to_file(base_64)
    regex = %r{\Adata:([-\w]+\/[-\w\+\.]+)?;base64,(.*)}m

    data_uri_parts = base_64.match(regex) || []
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
