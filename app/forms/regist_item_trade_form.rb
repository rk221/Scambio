class RegistItemTradeForm
    include ActiveModel::Model 

    attr_accessor :user_id, :game_id, :buy_item_name, :buy_item_quantity, :sale_item_name, :sale_item_quantity, :trade_deadline, :buy_item_genre_id, :sale_item_genre_id

    validates :game_id, presence: true
    validates :buy_item_name, presence: true, length: {maximum: 30}
    validates :buy_item_quantity, presence: true, numericality: {only_integer: true}
    validates :sale_item_name, presence: true, length: {maximum: 30}
    validates :sale_item_quantity, presence: true, numericality: {only_integer: true}
    validates :trade_deadline, presence: true
    validates :buy_item_genre_id, presence: true
    validates :sale_item_genre_id, presence: true

    def save 
        return false if invalid?
        buy_item = Item.find_by(name: buy_item_name, item_genre_id: buy_item_genre_id, game_id: game_id)
        if buy_item.nil?
            buy_item = Item.create(name: buy_item_name, item_genre_id: buy_item_genre_id, game_id: game_id)
        end
        sale_item = Item.find_by(name: sale_item_name, item_genre_id: sale_item_genre_id, game_id: game_id)
        if sale_item.nil?
            sale_item = Item.create(name: sale_item_name, item_genre_id: sale_item_genre_id, game_id: game_id)
        end
       
        itemtrade = ItemTrade.new(user_id: user_id, game_id: game_id, buy_item_id: buy_item.id, sale_item_id: sale_item.id, buy_item_quantity: buy_item_quantity, sale_item_quantity: sale_item_quantity, trade_deadline: Time.zone.now + trade_deadline.to_i.hours, enable_flag: true)

        return itemtrade.save
    end
end