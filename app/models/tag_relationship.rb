class TagRelationship < ActiveRecord::Base
  validates :tag_id, :question_id, presence: true
  belongs_to :tag
  belongs_to :question
end
