User.find_or_create_by(email: "test@test.com") do |u|
  u.first_name = "Test"
  u.last_name = "User"
  u.time_credits = 0
end

puts "Test user created!"
