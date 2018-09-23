json.id					delivery.id
json.droneId			delivery.drone_id
json.origin do
	json.latitude 		delivery.origin.latitude
	json.longitude 		delivery.origin.longitude
end
json.destination do
	json.latitude 		delivery.destination.latitude
	json.longitude 		delivery.destination.longitude
end
json.status				delivery.status
json.sender do
	json.id             sender.id
	json.firstName      sender.first_name
	json.lastName       sender.last_name
	json.email          sender.email
end
json.receiver do
	json.id             receiver.id
	json.firstName      receiver.first_name
	json.lastName       receiver.last_name
	json.email          receiver.email
end
json.createdDate		delivery.created_at
json.updatedDate		delivery.updated_at