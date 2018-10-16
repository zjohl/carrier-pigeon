module Api
  class DeliveriesController < ApplicationController

    def index
      render partial: "shared/json/deliveries.json", locals: {
          deliveries: Delivery.all,
      }
    end

    def show
      render partial: "shared/json/delivery.json", locals: {
          delivery: Delivery.find(params[:id]),
      }
    end

    def create
      params.permit(:drone_id, :status, :destination, :sender_id, :receiver_id, origin: [:latitude, :longitude])
      delivery = Delivery.create!(drone_id: params[:drone_id],
                                  status: params[:status],
                                  origin_latitude: params[:origin][:latitude],
                                  origin_longitude: params[:origin][:longitude],
                                  destination_latitude: params[:destination][:latitude],
                                  destination_longitude: params[:destination][:longitude],
                                  sender_id: params[:sender_id],
                                  receiver_id: params[:receiver_id])

      render partial: "shared/json/delivery.json", status: :created, locals: {
          delivery: delivery,
          sender: User.find(params[:sender_id]),
          receiver: User.find(params[:receiver_id])
      }
    end
  end
end
