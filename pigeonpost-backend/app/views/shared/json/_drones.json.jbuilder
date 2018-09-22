json.drones drones do |drone|
  json.partial! "shared/json/drone.json", locals: {
      drone: drone,
  }
end