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
  include Votable

  belongs_to :question, counter_cache: true
  belongs_to :user, counter_cache: true
  has_many :comments, as: :commentable
  has_many :attachments, as: :attachable

  accepts_nested_attributes_for :attachments

  validates :body, presence: true, length: { maximum: GlobalConstants::ANSWER_BODY_MAX_LENGTH }
  validates :question_id, :user_id, presence: true

  after_create :send_notification

  default_scope -> { order('created_at ASC') }

  def mark_best
    Answer.transaction do
      begin
        Answer.where(question: self.question).update_all(best: false)
        self.best = true
        self.user.update_rating(3)
        self.save
      rescue Exception
        raise ActiveRecord::Rollback
      end
    end
  end

  def send_notification
    question.subscriptions.each do |subscription|
      UserMailer.delay.new_question_answer(subscription.user, question, self) unless self.user == subscription.user
    end
  end
end
