class TagRelationship < ActiveRecord::Base
  belongs_to :tag
  belongs_to :question

  validates :tag, :question, presence: true
end
