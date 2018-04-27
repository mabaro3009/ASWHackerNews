json.extract! comment, :id, :text, :author_id, :votes, :parent_id, :created_at, :updated_at
json.url comment_url(comment, format: :json)
