json.id @comment.id
json.body @comment.body

json.user do
  json.id @comment.user.id
  json.screen_name @comment.user.screen_name
end

json.commentable do
  json.resource "#{@comment.commentable_type.downcase}s"
  json.id @comment.commentable_id
end