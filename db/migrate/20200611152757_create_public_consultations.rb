class CreatePublicConsultations < ActiveRecord::Migration[5.2]
  def change
    create_table :public_consultations do |t|
      t.string    :title
      t.string    :description
      t.string    :cover_image
      t.string    :documents, array: true, default: []
      t.datetime  :initial_date
      t.datetime  :final_date

      t.timestamps

      t.belongs_to :segment, foreign_key: true
    end
  end
end
