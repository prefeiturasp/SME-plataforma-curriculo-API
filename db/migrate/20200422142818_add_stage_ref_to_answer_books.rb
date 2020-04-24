class AddStageRefToAnswerBooks < ActiveRecord::Migration[5.2]
  def change
    add_reference :answer_books, :stage, index: true
  end
end

