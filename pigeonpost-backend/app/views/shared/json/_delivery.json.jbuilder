json.id					delivery.id
json.droneId			delivery.drone_id
json.origin do
	json.latitude 		delivery.origin_latitude
	json.longitude 		delivery.origin_longitude
end
json.destination do
	json.latitude 		delivery.destination_latitude
	json.longitude 		delivery.destination_longitude
end
json.status				delivery.status
json.sender do |sender|
	json.id             sender.id
	json.firstName      sender.first_name
	json.lastName       sender.last_name
end
json.receiver do |receiver|
	json.id             receiver.id
	json.firstName      receiver.first_name
	json.lastName       receiver.last_name
end
json.createdDate		delivery.created_at
json.updatedDate		delivery.updated_at