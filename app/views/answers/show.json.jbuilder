json.id answer.id
json.body answer.body

json.partial! 'shared/user', user: answer.user

json.comments answer.comments do |comment|
  json.id comment.id
  json.body comment.body

  json.partial! 'shared/user', user: comment.user

  json.attachments answer.attachments  do |attachment|
    json.filename attachment.file.identifier
    json.url attachment.file.url
  end
end