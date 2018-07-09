class AddColorToCurricularComponents < ActiveRecord::Migration[5.2]
  def change
    add_column :curricular_components, :color, :string
  end
end
