# create_table :answers, force: true do |t|
#   t.text     :body
#   t.datetime :created_at
#   t.datetime :updated_at
#   t.integer  :question_id
#   t.integer  :user_id
#   t.boolean  :best,        default: false
# end
#
# add_index :answers, [:user_id], name: :index_answers_on_user_id, using: :btree

class Answer < ActiveRecord::Base
  belongs_to :question, counter_cache: true
  belongs_to :user, counter_cache: true
  has_many :comments, as: :commentable
  has_many :attachments, as: :attachable

  accepts_nested_attributes_for :attachments

  validates :body, presence: true, length: { maximum: GlobalConstants::ANSWER_BODY_MAX_LENGTH }
  validates :question_id, :user_id, presence: true

  default_scope -> { order('created_at ASC') }

  def mark_best
    Answer.where(question: self.question).update_all(best: false)
    self.update_column(:best, true)
  end
end
