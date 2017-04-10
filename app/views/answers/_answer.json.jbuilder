json.(answer, :id, :user_id, :accepted)
json.body simple_format(answer.body)
json.created_at answer.created_at.strftime '%b %-d \'%y at %H:%M'
json.rating answer.rating

json.user do
  json.email answer.user.email
  json.avatar gravatar_image_url(answer.user.email)
end

json.attachments answer.attachments do |attachment|
  json.file do
    json.name attachment.file.identifier
    json.url  attachment.file.url
  end
end

json.question do
  json.author_id answer.question.user_id
end