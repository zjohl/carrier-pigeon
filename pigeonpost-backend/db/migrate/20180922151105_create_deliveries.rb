class CreateDeliveries < ActiveRecord::Migration[5.2]
  def change
    create_table :deliveries do |t|
    	t.integer :drone_id
    	t.string :status
    	t.float :origin_longitude
    	t.float :origin_latitude
    	t.float :destination_longitude
    	t.float :destination_latitude
    	t.integer :sender_id
    	t.integer :receiver_id
    	t.timestamps
    end
  end
end
