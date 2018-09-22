require "rails_helper"

RSpec.describe "Users", :type => :request do

  it "can list all users" do
    users = FactoryBot.create_list(:user, 2)

    get "/api/users"

    expect(response.content_type).to eq("application/json")
    expect(response).to have_http_status(:ok)

    json = JSON.parse(response.body)

    json_users = json['users']

    expect(json_users[0]['id']).to eq(users[0].id)
    expect(json_users[1]['id']).to eq(users[1].id)
  end

  it "can get a single user" do
    user = FactoryBot.create(:user)

    get "/api/users/#{user.id}"

    expect(response.content_type).to eq("application/json")
    expect(response).to have_http_status(:ok)

    json = JSON.parse(response.body)

    expect(json['id']).to eq(user.id)
    expect(json['email']).to eq(user.email)
    expect(json['password']).to eq(user.password)
    expect(json['firstName']).to eq(user.first_name)
    expect(json['lastName']).to eq(user.last_name)
  end

  it "can create a user" do
    post "/api/users", params: {
        email: "some-email",
        password: "some-password",
        first_name: "person-first",
        last_name: "person-last",
    }

    expect(response.content_type).to eq("application/json")
    expect(response).to have_http_status(:created)

    json = JSON.parse(response.body)

    expect(json['email']).to eq("some-email")
    expect(json['password']).to eq("some-password")
    expect(json['firstName']).to eq(  "person-first")
    expect(json['lastName']).to eq("person-last")
  end
end