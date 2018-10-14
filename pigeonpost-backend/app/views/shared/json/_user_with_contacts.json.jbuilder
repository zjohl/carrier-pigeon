json.id                   user.id
json.firstName            user.first_name
json.lastName             user.last_name
json.email                user.email
json.createdDate          user.created_at
json.contacts(contacts) do |contact|
  json.id                 contact.id
  json.firstName          contact.first_name
  json.lastName           contact.last_name
end