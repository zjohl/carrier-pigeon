json.users users do |user|
  json.partial! "shared/json/user.json", locals: {
      user: user,
  }
end