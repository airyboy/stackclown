class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :screen_name, :created_at, :updated_at
end
