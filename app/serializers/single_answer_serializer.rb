class SingleAnswerSerializer < AnswerSerializer
  has_many :attachments
  has_many :comments
end