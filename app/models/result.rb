class Result < ApplicationRecord
  include ArchivesConcern

  has_many :links, as: :linkable, dependent: :destroy

  belongs_to :challenge
  belongs_to :teacher

  default_scope { where enabled: true }

  validates :class_name, presence: true

  accepts_nested_attributes_for :links, allow_destroy: true

  def prev_result
    siblings.first
  end

  def next_result
    siblings.last
  end

  private

    def siblings
      return @siblings unless @siblings.blank?

      results = challenge.results.pluck :id
      index   = results.index id

      @siblings = [
        (index == 0 ? nil : results[index - 1]), results[index + 1]
      ]
    end
end
