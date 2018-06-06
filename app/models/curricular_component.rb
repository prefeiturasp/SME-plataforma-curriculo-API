class CurricularComponent < ApplicationRecord
  include FriendlyId
  has_and_belongs_to_many :activity_sequences
  has_many :axes, dependent: :destroy
  has_many :main_activity_sequences, class_name: 'ActivitySequence', foreign_key: :main_curricular_component_id
  has_many :learning_objectives

  validates :name, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true

  friendly_id :name, use: :slugged

  accepts_nested_attributes_for :axes, allow_destroy: true

  def should_generate_new_friendly_id?
    name_changed? || super
  end

  def initials
    return nil if name.blank?
    initials = initials_map[name.to_sym]
    return initials if initials.present?
    create_new_initials
  end

  private

  def create_new_initials
    split_name = name.split
    split_name.map { |s| s[0] if s.length >= 3 }.compact.join
  end

  def initials_map # rubocop:disable MethodLength
    {
      'Arte': 'A',
      'Ciências Naturais': 'C',
      'Educação Física': 'EF',
      'Geografia': 'G',
      'História': 'H',
      'Língua Portuguesa': 'LP',
      'Língua Inglesa': 'LI',
      'Matemática': 'M',
      'Tecnologias de Aprendizagem': 'TA'
    }
  end
end
