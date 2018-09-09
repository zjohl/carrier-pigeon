module Api
  class UsersController < ApplicationController
    def index
      render partial: "shared/json/users.json", locals: {
          users: User.all,
      }
    end

    def show
      render partial: "shared/json/user.json", locals: {
          users: User.find(params[:id]),
      }
    end
  end
end
