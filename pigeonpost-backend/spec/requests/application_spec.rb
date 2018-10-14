require "rails_helper"

RSpec.describe "Application", :type => :request do


  describe "auth" do
    it "can authenticate a user" do
      user = FactoryBot.create(:user)

      get "/api/auth", params: {email: user.email, password: user.password}

      expect(response.content_type).to eq("application/json")
      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)

      expect(json['id']).to eq(user.id)
      expect(json['email']).to eq(user.email)
      expect(json['firstName']).to eq(user.first_name)
      expect(json['lastName']).to eq(user.last_name)
    end

    it "returns 404 if user isn't found" do
      user = FactoryBot.create(:user)

      expect {
        get "/api/auth", params: {email: "wrong-email", password: "wrong-password"}
      }.to raise_error(ActionController::RoutingError)
    end

    it "returns 404 if password doesn't match" do
      user = FactoryBot.create(:user)

      expect {
        get "/api/auth", params: {email: user.email, password: "wrong-password"}
      }.to raise_error(ActionController::RoutingError)
    end
  end
end