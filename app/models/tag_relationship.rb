# create_table :tag_relationships, force: true do |t|
#   t.integer  :question_id
#   t.integer  :tag_id
#   t.datetime :created_at
#   t.datetime :updated_at
# end

class TagRelationship < ActiveRecord::Base
  belongs_to :tag
  belongs_to :question

  validates :tag, :question, presence: true
end
