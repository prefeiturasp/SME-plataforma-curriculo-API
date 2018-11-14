class Teacher < ApplicationRecord
  belongs_to :user

  validates :user_id, uniqueness: true

  has_one_attached :avatar
end
