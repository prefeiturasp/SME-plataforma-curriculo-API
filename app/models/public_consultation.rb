class PublicConsultation < ApplicationRecord
  belongs_to  :segment
  has_many :survey_forms
  validates :title, presence: true
  validates :description, presence: true
  validates :cover_image, presence: true
  validates :initial_date, presence: true
  validates :final_date, presence: true
  validate :initial_date_cannot_be_greater_than_final_date

  mount_uploaders :documents, PublicConsultationDocumentUploader
  mount_uploader :cover_image, PublicConsultationImageUploader

  def initial_date_cannot_be_greater_than_final_date
    if initial_date.present? && final_date.present? && initial_date > final_date
     errors.add(:initial_date, "Não pode ser maior que a data final")
   end
  end
end
