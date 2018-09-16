module Api
  class UsersController < ApplicationController
    def index
      render partial: "shared/json/users.json", locals: {
          users: User.all,
      }
    end

    def show
      render partial: "shared/json/user.json", locals: {
          users: User.find(params[:email]),
      }
    end

    def create
      params.require(:email).permit(:first_name, :last_name, :password)

      User.create(email: params[:email], first_name: params[:first_name], last_name: params[:last_name], password: params[:password])
    end
  end
end
