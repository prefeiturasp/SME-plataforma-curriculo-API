class CreatePublicConsultationLinks < ActiveRecord::Migration[5.2]
  def change
    create_table :public_consultation_links do |t|
      t.string :link
      t.string :title

      t.timestamps

      t.belongs_to :public_consultation, foreign_key: true
    end
  end
end
