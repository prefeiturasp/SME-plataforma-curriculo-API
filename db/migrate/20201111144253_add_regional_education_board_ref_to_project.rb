class AddRegionalEducationBoardRefToProject < ActiveRecord::Migration[5.2]
  def change
    add_reference :projects, :regional_education_board, index: true
  end
end
