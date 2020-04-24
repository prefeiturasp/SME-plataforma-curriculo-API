class Teacher < ApplicationRecord
  has_and_belongs_to_many :challenges
  has_many :collections, dependent: :destroy
  has_many :activity_sequence_performeds
  has_many :acls, dependent: :destroy
  belongs_to :user
  has_one_attached :avatar

  validates :user_id, uniqueness: true
  validates :nickname, length: { maximum: 15 }

  def number_of_sequences_not_evaluated
    activity_sequence_performeds.not_evaluateds.count
  end

  def number_of_collections
    collections.count
  end

  # TODO: change when inserting classes that come from SME
  def number_of_classes
    ''
  end

  # TODO: change when inserting components that come from SME
  def number_of_components
    ''
  end
end
