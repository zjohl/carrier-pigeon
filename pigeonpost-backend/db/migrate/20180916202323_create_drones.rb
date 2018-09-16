class CreateDrones < ActiveRecord::Migration[5.2]
  def change
    create_table :drones do |t|
    	t.float :latitude
    	t.float :longitude
 		t.float :destinationLatitude
 		t.float :destinationLongitude
    	t.string :status
    	t.integer :batteryPercent
    	t.timestamps
    end
  end
end
