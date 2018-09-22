require "rails_helper"

RSpec.describe "Users", :type => :request do

  it "creates a user" do
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