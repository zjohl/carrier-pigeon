module Api
  class DeliveriesController < ApplicationController
    # Make sure to remove this

    def index
      render partial: "shared/json/deliveries.json", locals: {
          deliveries: Delivery.includes(:sender, :receiver).all,
      }
    end

    def show
      delivery = Delivery.includes(:sender, :receiver).find(params[:id])
      render partial: "shared/json/delivery.json", locals: {
          delivery: delivery,
          sender: delivery.sender,
          receiver: delivery.receiver
      }
    end

    def create
      params.permit(:drone_id, :status, :origin, :destination, :sender_id, :receiver_id)
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
