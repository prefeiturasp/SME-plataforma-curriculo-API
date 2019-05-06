class Challenge < ApplicationRecord
  include FriendlyId
  include ImageConcern

  has_and_belongs_to_many :learning_objectives
  has_and_belongs_to_many :curricular_components
  has_and_belongs_to_many :knowledge_matrices

  has_many :axes, through: :learning_objectives
  has_many :sustainable_development_goals, through: :learning_objectives
  has_many :challenge_content_blocks, dependent: :destroy
  has_many :results, dependent: :destroy

  scope :finished, -> { where ['challenges.finish_at <= ?', DateTime.now] }
  scope :ongoing,  -> { where ['challenges.finish_at  > ?', DateTime.now] }

  enum category: { project: 0, make_and_remake: 1, games_and_investigation: 2 }
  enum status: { draft: 0, published: 1 }

  validates :title, presence: true, uniqueness: true
  validates :finish_at, presence: true
  validates :category, presence: true
  validates :learning_objectives, presence: true
  validates :slug, presence: true, uniqueness: true

  friendly_id :title, use: %i[slugged finders]

  accepts_nested_attributes_for :challenge_content_blocks, allow_destroy: true

  def bullet
    return @content_bullet unless @content_bullet.blank?

    _bullet = get_content_blocks.where(content_blocks: { content_type: :bullet }).first

    return nil if _bullet.blank?

    content = JSON.parse _bullet.content
    body    = JSON.parse content['body']

    @content_bullet ||= {
      title: content['title'],
      items: body['ops'].collect{|item| item['insert'] if item['attributes'].blank? }.compact
    }
  end

  def contents
    get_content_blocks.where.not content_blocks: { content_type: :bullet }
  end

  private

    def get_content_blocks
      @content_blocks ||= challenge_content_blocks.joins(:content_block)
    end
end
