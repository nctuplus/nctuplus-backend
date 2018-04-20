class ApiController < ActionController::Base
  def check_login
    if v1_user_signed_in?
      return true
    else
      render status: :bad_request, json: { 'msg' => 'user not login' }
      return false
    end
  end
end
