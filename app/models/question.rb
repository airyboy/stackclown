class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  has_many :comments, as: :commentable

  has_many :tag_relationships
  has_many :tags, through: :tag_relationships

  validates :title, presence: true, length: { maximum: GlobalConstants::QUESTION_TITLE_MAX_LENGTH }
  validates :body, presence: true, length: { maximum: GlobalConstants::QUESTION_BODY_MAX_LENGTH }

  def assign_tag(tag_name)
    tag = Tag.find_or_create_by(tag_name: tag_name)
    tag_relationships.find_or_create_by!(tag: tag, question: self)

    tag
  end

  def remove_tag(tag)
    tag_relationships.find_by(tag: tag, question: self).destroy
  end
end
