json.questions @questions do |question|
  json.extract! question, :id, :title, :answers_count, :created_at

  json.tags question.tags do |tag|
    json.extract! tag, :id, :tag_name
  end

  json.partial! 'shared/user', user: question.user
end