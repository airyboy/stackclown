json.questions @questions do |question|
  json.id question.id
  json.title question.title
  json.answers_count question.answers_count
  json.created_at question.created_at

  json.tags question.tags do |tag|
    json.id tag.id
    json.tag_name tag.tag_name
  end

  json.partial! 'shared/user', user: question.user
end