module Api
  class DronesController < ApplicationController
    # Make sure to remove this
    skip_before_action :verify_authenticity_token

    def index
      render partial: "shared/json/drones.json", locals: {
          drones: Drone.all,
      }
    end

    def show
      render partial: "shared/json/drone.json", locals: {
          drone: Drone.find(params[:id]),
      }
    end

    def create
      params.permit(:latitude, :longitude, :status, :battery_percent)

      drone = Drone.create!(latitude: params[:latitude],
                            longitude: params[:longitude],
                            status: params[:status],
                            battery_percent: params[:battery_percent])

      render partial: "shared/json/drone.json", status: :created, locals: {
          drone: drone,
      }
    end
  end
end
