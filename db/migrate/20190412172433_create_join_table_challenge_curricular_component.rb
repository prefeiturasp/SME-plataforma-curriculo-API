class CreateJoinTableChallengeCurricularComponent < ActiveRecord::Migration[5.2]
  def change
    create_join_table :challenges, :curricular_components do |t|
      t.index [:challenge_id, :curricular_component_id], name: 'index_c_cc_on_c_id_cc_id'
      t.index [:curricular_component_id, :challenge_id], name: 'index_c_lo_on_cc_id_c_id'
    end
  end
end
