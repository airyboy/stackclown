class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :best, :user_id, :question_id, :created_at, :updated_at
end