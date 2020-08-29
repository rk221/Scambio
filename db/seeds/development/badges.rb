def new_badge(row)
    badge = Badge.new(
        name: row['name'],
        item_trade_count_condition: row['item_trade_count_condition'],
        rank_condition: row['rank_condition'],
        description: row['description']
    )
end

CSV.foreach('db/seeds/development/csv/badges.csv', headers: true) do |row|
    if row['game_tltle']
        badge = new_badge(row)

        game = Game.find_by(title: row['game_title'])
        badge.game_id = game.id
        unless badge.save
            p "badge_save_error: #{badge.errors.full_messages}"
        end
    else
        Game.all.find_each do |game|
            badge = new_badge(row)
            badge.game_id = game.id

            unless badge.save
                p "badge_save_error: #{badge.errors.full_messages}"
            end
        end
    end
end