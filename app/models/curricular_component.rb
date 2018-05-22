class CurricularComponent < ApplicationRecord
  has_many :axes, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  accepts_nested_attributes_for :axes, allow_destroy: true

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
