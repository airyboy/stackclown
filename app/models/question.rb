# create_table :questions, force: true do |t|
#   t.string   :title
#   t.text     :body
#   t.datetime :created_at
#   t.datetime :updated_at
#   t.integer  :user_id
#   t.integer  :answers_count, default: 0
# end
#
# add_index :questions, [:user_id], name: :index_questions_on_user_id, using: :btree

class Question < ActiveRecord::Base
  attr_accessor :tags_comma_separated

  belongs_to :user, :counter_cache => true
  has_many :answers, dependent: :destroy
  has_many :comments, as: :commentable
  has_many :attachments, as: :attachable

  has_many :tag_relationships, dependent: :destroy
  has_many :tags, through: :tag_relationships

  accepts_nested_attributes_for :attachments, reject_if: proc {|attributes| attributes['file'].blank? }

  validates :title, presence: true, length: { maximum: GlobalConstants::QUESTION_TITLE_MAX_LENGTH }
  validates :body, presence: true, length: { maximum: GlobalConstants::QUESTION_BODY_MAX_LENGTH }
  validates :user_id, presence: true
  validates :tags_comma_separated, presence: true

  after_validation :make_tags

  def tags_comma_separated
    @tags_comma_separated ||= tags.map(&:tag_name).join(',')
  end

  private
    def make_tags
      tag_relationships.destroy_all
      tags_comma_separated.split(',').each do |tag|
        tags << Tag.find_or_initialize_by(tag_name: tag)
      end
    end
end
