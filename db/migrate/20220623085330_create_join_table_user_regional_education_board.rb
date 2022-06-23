class CreateJoinTableUserRegionalEducationBoard < ActiveRecord::Migration[5.2]
  def change
    create_join_table :users, :regional_education_boards
  end
end
