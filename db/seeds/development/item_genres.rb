CSV.foreach('db/seeds/development/csv/item_genres.csv', headers: true) do |row|
    item_genre = ItemGenre.new(name: row['name'] , default_unit_name: row['default_unit_name'])

    if item_genre.save 
        Game.all.find_each do |game|
            ItemGenreGame.create(game_id: game.id, item_genre_id: item_genre.id, enable: true)
        end
    else
        p "game_save_error: #{item_genre.errors}"
    end
end

# csvファイルに書き出し済みのアイテムジャンルゲーム設定を反映させる
CSV.foreach('db/seeds/development/csv/item_genre_games.csv', headers: true) do |row|
    game = Game.find_by(title: row['game_title'])
    item_genre = ItemGenre.find_by(name: row['genre_name'])
    item_genre_game = ItemGenreGame.find_by(item_genre_id: item_genre.id, game_id: game.id)
    unless item_genre_game.update(enable: row['enable'])
        p "item_genre_game_save_error: #{item_genre_game.errors}"
    end
end