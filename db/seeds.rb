# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.new(
    firstname: '管理者',
    lastname: 'ゆーざー',
    nickname: 'Admin',
    birthdate: 20.year.ago,
    email: 'admin@example.com' ,
    password: 'password' ,
    password_confirmation: 'password',
    confirmed_at: Time.zone.now,
    admin_flag: true 
)
user.save

user = User.new(
    firstname: '一般者',
    lastname: 'ゆーざー',
    nickname: 'General',
    birthdate: 20.year.ago,
    email: 'general@example.com' ,
    password: 'password' ,
    password_confirmation: 'password',
    confirmed_at: Time.zone.now,
    admin_flag: false 
)
user.save

game = Game.new(title: 'あつまれどうぶつの森')
game.save

item_genre = ItemGenre.new(name: '家具', default_unit_name: '個')
item_genre.save

item_genre_game = ItemGenreGame.new(enable_flag: true, game_id: game.id, item_genre_id: item_genre.id)
item_genre_game.save