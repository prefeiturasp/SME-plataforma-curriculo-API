class RemoveYearFromAnswerBooks < ActiveRecord::Migration[5.2]
  def change
    remove_column :answer_books, :year
    add_reference :answer_books, :year, index: true
  end
end
