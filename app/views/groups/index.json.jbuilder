json.array!(@groups) do |g|
  json.extract! g, :cn, :displayName, :description
end
