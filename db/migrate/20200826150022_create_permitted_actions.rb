class CreatePermittedActions < ActiveRecord::Migration[5.2]
  def change
    create_table :permitted_actions do |t|
      t.string :action_name
    end
  end
end
