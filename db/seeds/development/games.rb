CSV.foreach('db/seeds/development/csv/games.csv', headers: true) do |row|

    game = Game.new(title: row['title'])
    path = image_exist?(row['title'])
    game.image_icon = open(path) if path
    unless game.save
        p "game_save_error: #{game.errors}"
    end
end