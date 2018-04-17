class Api::V1::AuthController < ApiController
  def nctu
    auth = request.env['omniauth.auth']
    auth_record = AuthNctu.from_omniauth(auth)
    sign_in(auth_record.user, store: true) if auth_record.user
    redirect_to root_path
  end
end
