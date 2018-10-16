# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user1 = User.create!(email: "alice@test.test", first_name: "Alice", last_name: "Person", password: "Password")
user2 = User.create!(email: "bob@test.test", first_name: "Bob", last_name: "Person", password: "Password")
UserContact.create!(user_id: user1.id, contact_id: user2.id)
Drone.create!(status: "deliverating", battery_percent: 98, latitude: 111.1, longitude: 222.2, destination_latitude: 11.1, destination_longitude: 22.2)
Delivery.create!(drone_id: 1,
				 status: "completed",
 				 origin_latitude: 33.3,
 				 origin_longitude: 44.4,
 				 destination_latitude: 55.5,
 				 destination_longitude: 66.6,
				 sender_id: user1.id,
			 	 receiver_id: user2.id)