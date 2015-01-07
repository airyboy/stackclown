class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true
  belongs_to :user, counter_cache: true

  validates :body, presence: true, length: { maximum: GlobalConstants::COMMENT_BODY_MAX_LENGTH }
  validates :commentable_id, :user_id, presence: true

  default_scope -> { order('created_at ASC') }
end
