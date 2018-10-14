module Api
  class ContactsController < ApplicationController

    def create
      params.permit(:user_email_1, :user_email_2)

  	  user1 = User.find_by(email: params[:user_email_1])
	    user2 = User.find_by(email: params[:user_email_2])

	    if user1.nil? or user2.nil?
	    	raise ActionController::RoutingError.new('Not Found')
	    end

  	  contact = UserContact.find_or_create_by(user_id: user1.id, contact_id: user2.id)

  	  if contact.valid?
  	  	head :created
  	  else
  	  	raise ActionController::RoutingError.new('Not Found')
  	  end
    end

    def destroy
    	params.permit(:user_email_1, :user_email_2)

  	  user1 = User.find_by(email: params[:user_email_1])
	    user2 = User.find_by(email: params[:user_email_2])

    	contact = UserContact.find_by(user_id: user1.id, contact_id: user2.id)

    	if contact.present?
  	  	head :no_content
  	  else
  	  	raise ActionController::RoutingError.new('Not Found')
			end

			UserContact.destroy(contact.id)
      head :no_content
		end
  end
end