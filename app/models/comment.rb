# create_table :comments, force: true do |t|
#   t.text     :body
#   t.integer  :commentable_id
#   t.string   :commentable_type
#   t.datetime :created_at
#   t.datetime :updated_at
#   t.integer  :user_id
# end
#
# add_index :comments, [:commentable_id, :commentable_type], name: :index_comments_on_commentable_id_and_commentable_type, using: :btree
# add_index :comments, [:user_id], name: :index_comments_on_user_id, using: :btree

class Comment < ActiveRecord::Base
  include Votable

  belongs_to :commentable, polymorphic: true
  belongs_to :user, counter_cache: true

  validates :body, presence: true, length: { maximum: GlobalConstants::COMMENT_BODY_MAX_LENGTH }
  validates :commentable_id, :user_id, presence: true

  default_scope -> { order('created_at ASC') }

  def question
    if commentable_type == 'Question'
      self.commentable
    else
      self.commentable.question
    end
  end
end
