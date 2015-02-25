json.answers_count @question.answers.size

json.answers @answers do |answer|
  json.id answer.id
  json.body answer.body
  json.created_at answer.created_at
  json.points answer.total_points

  json.partial! 'shared/user', user: answer.user

  json.attachments answer.attachments  do |attachment|
    json.filename attachment.file.identifier
    json.url attachment.file.url
  end

  json.comments answer.comments do |comment|
    json.id comment.id
    json.body comment.body
    json.partial! 'shared/user', user: comment.user
  end
end