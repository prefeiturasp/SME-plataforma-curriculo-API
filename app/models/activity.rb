class Activity < ApplicationRecord
  include FriendlyId
  include ImageConcern

  belongs_to :activity_sequence
  has_and_belongs_to_many :activity_types
  has_and_belongs_to_many :curricular_components
  has_and_belongs_to_many :learning_objectives
  has_many :activity_content_blocks, dependent: :destroy

  accepts_nested_attributes_for :activity_content_blocks, allow_destroy: true

  validates :title, presence: true, uniqueness: true
  validates :slug, presence: true
  validates :sequence, presence: true

  enum environment: { interior: 0, exterior: 1 }
  enum status: { draft: 0, published: 1 }

  has_many_attached :content_images

  friendly_id :title, use: %i[slugged finders]

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

  private

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
