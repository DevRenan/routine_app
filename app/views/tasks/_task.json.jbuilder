json.extract! task, :id, :title, :description, :weight, :category_id, :frequency_id, :created_at, :updated_at
json.url task_url(task, format: :json)
