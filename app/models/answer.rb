class Answer < ActiveRecord::Base
  validates :body, presence: true, length: { maximum: GlobalConstants::ANSWER_BODY_MAX_LENGTH }
  validates :question_id, presence: true

  belongs_to :question

  has_many :comments, as: :commentable

  default_scope -> { order('created_at ASC') }
end
