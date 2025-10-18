# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

50.times do |i|
  v = Villa.create(name: 'Villa-' + i.to_s)
  stay_date = Date.new(2025,1,1)
  end_date = Date.new(2025,12,31)
  while stay_date <= end_date
    Calender.create(villa: v, stay_date:, available: rand(0..1), price: rand(30000..50000))
    stay_date += 1
  end
end