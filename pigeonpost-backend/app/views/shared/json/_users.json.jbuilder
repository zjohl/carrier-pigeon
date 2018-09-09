json.users users do |users|
  json.partial! "shared/json/user.json", locals: {
      user: user,
  }
end