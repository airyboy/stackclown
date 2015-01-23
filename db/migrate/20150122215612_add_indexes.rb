class AddIndexes < ActiveRecord::Migration
  def change
    add_index :authentications, [:user_id, :provider]
    add_index :comments, [:commentable_id, :commentable_type]
    add_index :tags, :tag_name
    add_index :attachments, [:attachable_id, :attachable_type]
  end
end
