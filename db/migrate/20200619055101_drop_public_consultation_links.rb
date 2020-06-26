class DropPublicConsultationLinks < ActiveRecord::Migration[5.2]
  def change
    drop_table :public_consultation_links
  end
end
