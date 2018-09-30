class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token

  def auth
    params.permit(:email, :password)

    user = User.find_by(email: params[:email])

    if user.present? && user.password == params[:password]
      head :ok, content_type: "text/html"
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end
end
