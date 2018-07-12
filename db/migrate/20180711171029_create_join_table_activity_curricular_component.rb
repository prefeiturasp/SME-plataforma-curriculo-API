class CreateJoinTableActivityCurricularComponent < ActiveRecord::Migration[5.2]
  def change
    create_join_table :activities, :curricular_components do |t|
      t.index [:activity_id, :curricular_component_id], name: 'index_activity_component_on_activity_id_and_component_id'
      t.index [:curricular_component_id, :activity_id], name: 'index_activity_component_on_component_id_and_activity_id'
    end
  end
end
