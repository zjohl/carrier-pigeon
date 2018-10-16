module Api
  class DronesController < ApplicationController

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
      params.permit(:status, :battery_percent, position: [:latitude, :longitude])

      drone = Drone.create!(latitude: params[:position][:latitude],
                            longitude: params[:position][:longitude],
                            status: params[:status],
                            battery_percent: params[:battery_percent])

      render partial: "shared/json/drone.json", status: :created, locals: {
          drone: drone,
      }
    end
  end
end
