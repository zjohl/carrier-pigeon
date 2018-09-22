class CreateDrones < ActiveRecord::Migration[5.2]
  def change
    create_table :drones do |t|
    	t.float :latitude
    	t.float :longitude
 		  t.float :destination_latitude
 		  t.float :destination_longitude
    	t.string :status
    	t.integer :battery_percent
    	t.timestamps
    end
  end
end
