json.array!(@users) do |u|
  json.name_and_nick u.name_and_nick
  json.value u.dn.to_s
end
