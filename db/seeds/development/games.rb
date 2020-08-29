CSV.foreach('db/seeds/development/csv/games.csv', headers: true) do |row|
    game = Game.new(title: row['title'])
    unless game.save 
        p "game_save_error: #{game.errors}"
    end
end