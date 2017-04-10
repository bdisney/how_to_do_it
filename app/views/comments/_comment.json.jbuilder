json.(comment, :id, :user_id, :body)

json.parent do
  json.type comment.commentable_type.underscore
  json.id comment.commentable_id
end

json.user do
  json.email comment.user.email
end