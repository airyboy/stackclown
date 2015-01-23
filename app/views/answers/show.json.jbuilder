json.id answer.id
json.body answer.body

json.user do
  json.id answer.user.id
  json.screen_name answer.user.screen_name
end

json.comments answer.comments do |comment|
  json.id comment.id
  json.body comment.body

  json.user do
    json.id comment.user.id
    json.screen_name comment.user.screen_name
  end

  json.attachments answer.attachments  do |attachment|
    json.filename attachment.file.identifier
    json.url attachment.file.url
  end
end