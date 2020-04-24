class AddSegmentRefToAnswerBooks < ActiveRecord::Migration[5.2]
  def change
    add_reference :answer_books, :segment, index: true
  end
end
