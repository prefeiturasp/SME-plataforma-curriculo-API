class RemoveCurricularComponentRefFromComplementBooks < ActiveRecord::Migration[5.2]
  def change
    remove_column :complement_books, :curricular_component_id, :index
    remove_column :complement_books, :description, :string
  end
end
