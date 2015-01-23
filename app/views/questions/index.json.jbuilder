json.questions @questions do |question|
  json.id question.id
  json.title question.title
  json.answers_count question.answers_count

  json.tags question.tags do |tag|
    json.id tag.id
    json.tag_name tag.tag_name
  end

  json.user do
    json.id question.user.id
    json.screen_name question.user.screen_name
  end
end