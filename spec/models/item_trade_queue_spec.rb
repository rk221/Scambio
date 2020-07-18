require 'rails_helper'

RSpec.describe ItemTradeQueue, type: :model do
  let!(:user){create(:user)}
  let!(:item_genre){create(:item_genre)}
  let!(:game){create(:game)}
  let!(:buy_item){create(:buy_item, item_genre: item_genre, game: game)}
  let!(:sale_item){create(:sale_item, item_genre: item_genre, game: game)}
  let!(:user_game_rank){create(:user_game_rank, user: user, game: game)}
  let!(:item_trade){create(:item_trade, user: user, game: game, buy_item: buy_item, sale_item: sale_item, user_game_rank: user_game_rank)}
  
  it "is valid with valid attributes" do
    item_trade_queue = build(:item_trade_queue, user: user, item_trade: item_trade, establish: false)
    expect(item_trade_queue).to be_valid
  end

  it "is not valid without an item_trade_id" do
    item_trade_queue = build(:item_trade_queue, user: user, item_trade: nil)
    item_trade_queue.valid?
    expect(item_trade_queue.errors[:item_trade_id]).to include("を入力してください")
  end
end
