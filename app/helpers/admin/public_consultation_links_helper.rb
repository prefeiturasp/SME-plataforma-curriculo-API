module Admin
  module PublicConsultationLinksHelper
    def public_consultation_collection(public_consultation_id)
      public_consultations = PublicConsultation.where(id: public_consultation_id)
      public_consultations.collect do |public_consultation|
        [public_consultation.title, public_consultation.id]
      end
    end
  end
end
