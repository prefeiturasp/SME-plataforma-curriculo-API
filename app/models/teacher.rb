class Teacher < ApplicationRecord
  belongs_to :user

  validates :user_id, uniqueness: true
  validates :nickname, length: { maximum: 15 }

  has_one_attached :avatar
end
