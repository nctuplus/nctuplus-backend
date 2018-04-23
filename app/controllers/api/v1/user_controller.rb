class Api::V1::UserController < ApiController
  before_action :check_login, :only => [:index]

  def index
    render json: { data: current_v1_user.as_json(except: [ :provider, :tokens ], methods: :avatar_url) }
  end
end
