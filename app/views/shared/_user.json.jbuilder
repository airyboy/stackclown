json.user do
  json.id user.id
  json.screen_name user.screen_name
  json.avatar_thumb user.avatar.thumb.url
end