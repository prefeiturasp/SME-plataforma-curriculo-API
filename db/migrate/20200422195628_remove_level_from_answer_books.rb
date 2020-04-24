class RemoveLevelFromAnswerBooks < ActiveRecord::Migration[5.2]
  def change
    remove_column :answer_books, :level
  end
end
