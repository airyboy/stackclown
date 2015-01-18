json.id @comment.id
json.body @comment.body

json.user do
  json.id @comment.user.id
  json.email @comment.user.email
end