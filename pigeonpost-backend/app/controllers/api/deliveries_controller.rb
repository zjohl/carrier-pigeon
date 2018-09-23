module Api
  class DeliveriesController < ApplicationController
    # Make sure to remove this
    skip_before_action :verify_authenticity_token

    def index
      render partial: "shared/json/deliveries.json", locals: {
          deliveries: Deliveries.all,
      }
    end

    def show
      render partial: "shared/json/deliveries.json", locals: {
          drone: Deliveries.find(params[:id]),
      }
    end

    def create
      params.permit(:drone_id, :status, :origin, :destination, :sender_id, :receiver_id)

      delivery = Deliveries.create!(drone_id: params[:drone_id],
                                    status: params[:status],
                                    origin: params[:origin],
                                    destination: params[:destination],
                                    sender_id: params[:sender_id],
                                    receiver_id: params[:receiver_id])

      render partial: "shared/json/delivery.json", locals: {
          delivery: delivery,
          sender: Users.find(params[:sender_id],
          receiver: Users.find(params[:receiver_id])
      }
    end
  end
end
