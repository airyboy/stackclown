class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true

  validates :body, presence: true, length: { maximum: GlobalConstants::COMMENT_BODY_MAX_LENGTH }
  validates :commentable_id, presence: true

  default_scope -> { order('created_at ASC') }
end
