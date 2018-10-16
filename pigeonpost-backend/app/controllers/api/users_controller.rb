module Api
  class UsersController < ApplicationController

    def index
      render partial: "shared/json/users.json", locals: {
          users: User.all,
      }
    end

    def show
      user = User.find(params[:id])
      render partial: "shared/json/user_with_contacts.json", locals: {
          user: user,
          contacts: user.contacts,
      }
    end

    def create
      params.permit(:email, :first_name, :last_name, :password)

      user = User.create!(email: params[:email], first_name: params[:first_name], last_name: params[:last_name], password: params[:password])

      render partial: "shared/json/user.json", status: :created, locals: {
          user: user,
      }
    end
  end
end
