json.array!(@groups) do |g|
  json.extract! g, :cn, :displayName, :description, :mail,
    :homepage, :type, :function, :groupLogo
end
