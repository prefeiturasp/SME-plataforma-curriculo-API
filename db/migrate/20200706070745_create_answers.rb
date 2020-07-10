class CreateAnswers < ActiveRecord::Migration[5.2]
  def change
    create_table :answers do |t|
      t.string :comment
      t.integer :rating
      t.belongs_to :survey_form_answer, foreign_key: true
      t.belongs_to :survey_form_content_block, foreign_key: true
      t.belongs_to :teacher, foreign_key: true
    end
  end
end
