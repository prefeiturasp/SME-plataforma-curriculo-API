class AddEnvironmentToActivity < ActiveRecord::Migration[5.2]
  def change
  	add_column :activities, :environment, :integer
  end
end
