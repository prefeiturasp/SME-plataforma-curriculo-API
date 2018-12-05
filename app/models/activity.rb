class Activity < ApplicationRecord
  include FriendlyId
  include ImageConcern

  belongs_to :activity_sequence
  has_and_belongs_to_many :activity_types
  has_and_belongs_to_many :curricular_components
  has_and_belongs_to_many :learning_objectives
  has_many :activity_content_blocks

  accepts_nested_attributes_for :activity_content_blocks, allow_destroy: true

  validates :title, presence: true, uniqueness: true
  validates :content, presence: true
  validates :slug, presence: true
  validates :sequence, presence: true

  enum environment: { interior: 0, exterior: 1 }

  has_many_attached :content_images

  friendly_id :title, use: %i[slugged finders]

  before_save :change_format_content_images

  after_save    :update_sequences, on: %i[create update]
  after_destroy :update_sequences

  def next_activity
    activity_sequence.activities
                     .where('sequence >= ?', next_sequence)
                     .order('sequence ASC').first
  end

  def last_activity
    return unless last_sequence
    activity_sequence.activities
                     .where('sequence <= ?', last_sequence)
                     .order('sequence ASC').last
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

  private

  def change_format_content_images
    return nil if content.blank?
    content_json = JSON.parse(content)
    content_json['ops'].each do |c|
      uri_parts = extract_image(c['insert']['image'])
      next if uri_parts.blank?
      c['insert']['image'] = base64_to_url(uri_parts)
    end

    self.content = content_json.to_json
  end

  def extract_image(base_64)
    return if base_64.blank? || base_64&.include?('/rails/active_storage/blobs/')
    regex = %r{\Adata:([-\w]+\/[-\w\+\.]+)?;base64,(.*)}m
    base_64.match(regex) || []
  end

  def update_sequences
    return if valid_sequence?
    activity_sequence.activities.order(:sequence, updated_at: :desc).each.with_index(1) do |k, i|
      k.update_column(:sequence, i) if k.sequence != i
    end
  end

  def valid_sequence?
    sequences = activity_sequence.activities.order(:sequence).pluck(:sequence)
    valid_sequence = (1..sequences.count).to_a

    sequences == valid_sequence
  end
end
