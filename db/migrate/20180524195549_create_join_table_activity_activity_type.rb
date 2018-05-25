class CreateJoinTableActivityActivityType < ActiveRecord::Migration[5.2]
  def change
    create_join_table :activities, :activity_types do |t|
      t.index [:activity_id, :activity_type_id], name: 'idx_act_act_types_on_activity_id_and_activity_type_id'
      t.index [:activity_type_id, :activity_id], name: 'idx_act_act_types_on_activity_type_id_and_activity_id'
    end
  end
end
