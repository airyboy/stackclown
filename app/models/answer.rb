class Answer < ActiveRecord::Base
  validates :body, presence: true, length: { maximum: 10000 }
  validates :question_id, presence: true

  belongs_to :question

  default_scope -> { order('created_at ASC') }
end
