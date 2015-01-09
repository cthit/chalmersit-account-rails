json.array!(@users) do |u|
  json.extract! u, :uid, :display_name
end
