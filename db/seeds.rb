# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require "csv"
# データを投入するテーブル名を指定(seeds/以下のファイル名, 作成順に気を付ける)
table_names = %w(users games badges item_genres)

# ファイルの読み込み
table_names.each do |table_name|
    environment = (Rails.env == "test") ? "development" : Rails.env
    
	path = Rails.root.join("db/seeds", environment, table_name + ".rb")
    if File.exist?(path)
        puts "#{table_name}..."
        require path
    end
end