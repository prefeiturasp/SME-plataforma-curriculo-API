class PublicConsultationLink < ApplicationRecord
  belongs_to  :public_consultation

  validates :title, presence: true
  validates :link, presence: true
end
