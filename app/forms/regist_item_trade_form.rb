class RegistItemTradeForm
    include ActiveModel::Model 

    attr_accessor :id, :user_id, :game_id, :buy_item_name, :buy_item_quantity, :sale_item_name, :sale_item_quantity, :numeric_of_trade_deadline, :buy_item_genre_id, :sale_item_genre_id, :user_game_rank_id

    validates :user_id, presence: true
    validates :game_id, presence: true
    validates :buy_item_name, presence: true, length: {maximum: 30}
    validates :buy_item_quantity, presence: true, numericality: {only_integer: true}
    validates :sale_item_name, presence: true, length: {maximum: 30}
    validates :sale_item_quantity, presence: true, numericality: {only_integer: true}
    validates :numeric_of_trade_deadline, presence: true, numericality: {greater_than_or_equal_to: 1, less_than_or_equal_to: 24}
    validates :buy_item_genre_id, presence: true
    validates :sale_item_genre_id, presence: true
    validates :user_game_rank_id, presence: true

    def save 
        return false if invalid?

        # ジャンルIDがそのゲームでは使用できない物の場合
        return false unless ItemGenreGame.find_by(item_genre_id: buy_item_genre_id, game_id: game_id).enable
        return false unless ItemGenreGame.find_by(item_genre_id: sale_item_genre_id, game_id: game_id).enable

        # 購入アイテム、売却アイテムなければ作成、有ればidを格納する
        buy_item = Item.find_by(name: buy_item_name, item_genre_id: buy_item_genre_id, game_id: game_id)
        if buy_item.nil?
            buy_item = Item.create!(name: buy_item_name, item_genre_id: buy_item_genre_id, game_id: game_id)
        end
        sale_item = Item.find_by(name: sale_item_name, item_genre_id: sale_item_genre_id, game_id: game_id)
        if sale_item.nil?
            sale_item = Item.create!(name: sale_item_name, item_genre_id: sale_item_genre_id, game_id: game_id)
        end
       
        # item_tradeの保存
        item_trade = ItemTrade.new(user_id: user_id, game_id: game_id, buy_item_id: buy_item.id, sale_item_id: sale_item.id, buy_item_quantity: buy_item_quantity, sale_item_quantity: sale_item_quantity, numeric_of_trade_deadline: numeric_of_trade_deadline, enable: true, user_game_rank_id: user_game_rank_id)
        item_trade.save
    end
end