json.array!(@users) do |user|
  json.extract! user, :id , :username , :password , :email 
end
