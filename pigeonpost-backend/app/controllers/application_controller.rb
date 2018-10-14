class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token

  def auth
    params.permit(:email, :password)

    user = User.find_by(email: params[:email])

    if user.present? && user.password == params[:password]
      render partial: "shared/json/user.json", status: :ok, locals: {
          user: user,
      }
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end
end
