class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :year, :department_id, :agree, :agree_share, :role, :email
  attribute :avatar_url do |object|
    object.avatar_url
  end
end
