class SurveyForm < ApplicationRecord
  belongs_to :public_consultation
  has_many :survey_form_content_blocks, dependent: :destroy
  has_many :survey_form_answers, dependent: :restrict_with_error

  accepts_nested_attributes_for :survey_form_content_blocks, allow_destroy: true

  validates :title, presence: true
  validates :description, presence: true
  validates :sequence, presence: true

  after_save    :update_sequences, on: %i[create update]
  after_destroy :update_sequences

  def next_object
    public_consultation.survey_forms
    .where('sequence >= ?', next_sequence)
    .order('sequence ASC').first
  end

  def last_object
    return unless last_sequence
    public_consultation.survey_forms
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

  private

  def update_sequences
    return if valid_sequence?
    public_consultation.survey_forms.order(:sequence, updated_at: :desc).each.with_index(1) do |k, i|
      k.update_column(:sequence, i) if k.sequence != i
    end
  end

  def valid_sequence?
    sequences = public_consultation.survey_forms.order(:sequence).pluck(:sequence)
    valid_sequence = (1..sequences.count).to_a

    sequences == valid_sequence
  end
end
