class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true

  validates :body, presence: true, length: { maximum: 1000 }
  validates :commentable_id, presence: true
end
