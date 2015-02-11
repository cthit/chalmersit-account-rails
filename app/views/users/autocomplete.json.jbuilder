json.array!(@users) do |u|
  json.display_name u.display_name
  json.value u.dn.to_s
end
