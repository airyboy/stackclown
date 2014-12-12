class TagRelationship < ActiveRecord::Base
  belongs_to :tag
  belongs_to :question

  validates :tag_id, :question_id, presence: true
end
