json.answers_count @question.answers.size


json.answers @answers do |answer|
  json.cache! [answer, answer.best] do
    json.extract! answer, :id, :body, :created_at, :best
    json.points answer.total_points

    json.partial! 'shared/user', user: answer.user

    json.attachments answer.attachments  do |attachment|
      json.filename attachment.file.identifier
      json.url attachment.file.url
    end

    json.comments answer.comments do |comment|
      json.extract! comment, :id, :body
      json.partial! 'shared/user', user: comment.user
    end
  end
end