class Question < ActiveRecord::Base
  validates :title, presence: true, length: { maximum: GlobalConstants::QUESTION_TITLE_MAX_LENGTH }
  validates :body, presence: true, length: { maximum: GlobalConstants::QUESTION_BODY_MAX_LENGTH }

  has_many :answers, dependent: :destroy
  has_many :comments, as: :commentable

  has_many :tag_relationships
  has_many :tags, through: :tag_relationships

  def assign_tag(tag_name)
    tag = Tag.find_or_create_by(tag_name: tag_name)
    tag_relationships.find_or_create_by!(tag_id: tag.id, question_id: self.id)

    tag
  end
end
