namespace :update_user_game_rank_id_to_item_trades do
    desc "アイテムトレードのuser_game_rank_idを再格納する" # アップデート用
    task update: :environment do
        ItemTrade.all.each do |item_trade|
            item_trade.update!(user_game_rank_id: UserGameRank.find_by(user_id: item_trade.user_id, game_id: item_trade.game_id).id)
        end
    end
end
