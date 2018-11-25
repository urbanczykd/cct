# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

(2..20).each do |num|
  User.create(:email => "urbanczykd#{num}@gmail.com", :password => "darek123", :password_confirmation => "darek123")
end
