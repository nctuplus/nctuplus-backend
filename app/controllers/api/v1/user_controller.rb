class Api::V1::UserController < ApiController
  before_action :check_login, :only => [:index]

  def index
    render json: UserSerializer.new(current_v1_user).serialized_json
  end
end
