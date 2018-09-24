require "rails_helper"

RSpec.describe "Deliveries", :type => :request do

    it "can list all deliveries" do
        deliveries = FactoryBot.create_list(:delivery, 2)

        get "/api/deliveries"

        expect(response.content_type).to eq("application/json")
        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)

        json_deliveries = json['deliveries']

        expect(json_deliveries[0]['id']).to eq(deliveries[0].id)
        expect(json_deliveries[1]['id']).to eq(deliveries[1].id)
    end

    it "can get a single delivery" do
        delivery = FactoryBot.create(:delivery)

        get "/api/deliveries/#{delivery.id}"

        expect(response.content_type).to eq("application/json")
        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)

        expect(json['id']).to eq(delivery.id)
        expect(json['origin']['latitude']).to eq(delivery.origin_latitude)
        expect(json['origin']['longitude']).to eq(delivery.origin_longitude)
    end

    it "can create a new delivery" do
        sender = FactoryBot.create(:user)
        receiver = FactoryBot.create(:user)

        post "/api/deliveries", params: {
            drone_id: 1,
            status: "great",
            origin: {
                latitude: 2,
                longitude: 3
            },
            destination: {
                latitude: 4,
                longitude: 5
            },
            sender_id: sender.id,
            receiver_id: receiver.id
        }
        
        expect(response.content_type).to eq("application/json")
        expect(response).to have_http_status(:created)

        json = JSON.parse(response.body)
        expect(json['droneId']).to eq(1)
    end
end