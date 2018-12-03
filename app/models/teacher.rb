class Teacher < ApplicationRecord
  has_many :collections, dependent: :destroy
  belongs_to :user
  has_one_attached :avatar

  validates :user_id, uniqueness: true
  validates :nickname, length: { maximum: 15 }

  def name
    user.name
  end
end
