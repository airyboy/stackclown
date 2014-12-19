class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  has_many :comments, as: :commentable

  validates :body, presence: true, length: { maximum: GlobalConstants::ANSWER_BODY_MAX_LENGTH }
  validates :question_id, :user_id, presence: true

  default_scope -> { order('created_at ASC') }
end
