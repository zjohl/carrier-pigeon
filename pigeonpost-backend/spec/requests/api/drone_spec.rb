require "rails_helper"

RSpec.describe "Drones", :type => :request do

  it "can list all drones" do
    drones = FactoryBot.create_list(:drone, 2)

    get "/api/drones"

    expect(response.content_type).to eq("application/json")
    expect(response).to have_http_status(:ok)

    json = JSON.parse(response.body)

    json_drones = json['drones']

    expect(json_drones[0]['id']).to eq(drones[0].id)
    expect(json_drones[1]['id']).to eq(drones[1].id)
  end

  it "can get a single drone" do
    drone = FactoryBot.create(:drone)

    get "/api/drones/#{drone.id}"

    expect(response.content_type).to eq("application/json")
    expect(response).to have_http_status(:ok)

    json = JSON.parse(response.body)

    expect(json['id']).to eq(drone.id)
    expect(json['position']['latitude']).to eq(drone.latitude)
    expect(json['position']['longitude']).to eq(drone.longitude)
    expect(json['status']).to eq(drone.status)
    expect(json['batteryPercent']).to eq(drone.battery_percent)
  end

  it "can create a new drone" do
    post "/api/drones", params: {
       position: {
        latitude: 17,
        longitude: 23
       },
       status: "cool",
       battery_percent: 1,
    }

    expect(response.content_type).to eq("application/json")
    expect(response).to have_http_status(:created)

    json = JSON.parse(response.body)

    expect(json['position']['latitude']).to eq(17)
    expect(json['position']['longitude']).to eq(23)
    expect(json['status']).to eq("cool")
    expect(json['batteryPercent']).to eq(1)
  end
end