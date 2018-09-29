json.id					drone.id
json.position do
	json.latitude 		drone.latitude
	json.longitude 		drone.longitude
end
json.destination do
	json.latitude 		drone.destination_latitude
	json.longitude 		drone.destination_longitude
end
json.status				drone.status
json.batteryPercent		drone.battery_percent
json.createdDate		drone.created_at
json.updatedDate		drone.updated_at
