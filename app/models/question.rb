class Question < ActiveRecord::Base
  attr_accessor :tags_comma_separated

  def tag_list
    self.tags.map {|t| t.tag_name}.join(',')
  end

  belongs_to :user, :counter_cache => true
  has_many :answers, dependent: :destroy
  has_many :comments, as: :commentable
  has_many :attachments, as: :attachable

  has_many :tag_relationships
  has_many :tags, through: :tag_relationships

  accepts_nested_attributes_for :attachments, reject_if: proc {|attributes| attributes['file'].blank? }

  validates :title, presence: true, length: { maximum: GlobalConstants::QUESTION_TITLE_MAX_LENGTH }
  validates :body, presence: true, length: { maximum: GlobalConstants::QUESTION_BODY_MAX_LENGTH }
  validates :user_id, presence: true
  validates :tags_comma_separated, presence: true

  def make_tags
    self.tags.destroy_all
    tags_comma_separated.split(',').each do |tag|
      assign_tag(tag)
    end
  end

  def assign_tag(tag_name)
    tag = Tag.find_or_create_by(tag_name: tag_name)
    unless self.tags.include?(tag)
      self.tags << tag
    end

    tag
  end

  def remove_tag(tag)
    tag_relationships.find_by(tag: tag, question: self).destroy
  end
end
