class Answer < ActiveRecord::Base
  belongs_to :question, counter_cache: true
  belongs_to :user, counter_cache: true
  has_many :comments, as: :commentable
  has_many :attachments, as: :attachable

  accepts_nested_attributes_for :attachments

  validates :body, presence: true, length: { maximum: GlobalConstants::ANSWER_BODY_MAX_LENGTH }
  validates :question_id, :user_id, presence: true

  default_scope -> { order('created_at ASC') }
end
