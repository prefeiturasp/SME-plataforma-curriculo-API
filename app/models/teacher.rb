class Teacher < ApplicationRecord
  has_many :collections, dependent: :destroy
  has_many :activity_sequence_performeds
  belongs_to :user
  has_one_attached :avatar

  validates :user_id, uniqueness: true
  validates :nickname, length: { maximum: 15 }

  def name
    user.username
  end

  def number_of_sequences_not_evaluated
    activity_sequence_performeds.not_evaluateds.count
  end

  def number_of_collections
    collections.count
  end

  # TODO: change when inserting classes that come from SME
  def number_of_classes
    rand(1..10)
  end

  # TODO: change when inserting components that come from SME
  def number_of_components
    rand(1..10)
  end
end
