module Api
  class UsersController < ApplicationController
    # Make sure to remove this
    skip_before_action :verify_authenticity_token

    def index
      render partial: "shared/json/users.json", locals: {
          users: User.all,
      }
    end

    def show
      render partial: "shared/json/user.json", locals: {
          user: User.find(params[:id]),
      }
    end

    def create
      params.permit(:email, :first_name, :last_name, :password)

      user = User.create!(email: params[:email], first_name: params[:first_name], last_name: params[:last_name], password: params[:password])

      render partial: "shared/json/user.json", locals: {
          user: user,
      }
    end
  end
end
