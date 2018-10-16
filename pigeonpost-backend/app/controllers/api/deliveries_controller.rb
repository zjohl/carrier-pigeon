module Api
  class DeliveriesController < ApplicationController

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

    def index_by_user_and_status
      params.permit(:user_id, :status)
      deliveries = Delivery.includes(:sender, :receiver)
        .where("deliveries.sender_id = ? OR deliveries.receiver_id = ?",
         params[:user_id],
         params[:user_id])

      if params[:status] != nil
        deliveries = deliveries.where(status: params[:status])
      end

      render partial: "shared/json/deliveries.json", locals: {
          deliveries: deliveries
      }
    end
  end
end
