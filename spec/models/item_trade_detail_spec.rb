require 'rails_helper'

RSpec.describe ItemTradeDetail, type: :model do
  let!(:user){FactoryBot.create(:user)}
  let!(:item_genre){FactoryBot.create(:item_genre)}
  let!(:game){FactoryBot.create(:game)}
  let!(:buy_item){FactoryBot.create(:buy_item, item_genre_id: item_genre.id, game_id: game.id)}
  let!(:sale_item){FactoryBot.create(:sale_item, item_genre_id: item_genre.id, game_id: game.id)}
  let!(:item_trade){FactoryBot.create(:item_trade, user_id: user.id, game_id: game.id, buy_item_id: buy_item.id, sale_item_id: sale_item.id)}
  let!(:item_trade_queue){FactoryBot.create(:item_trade_queue, user_id: user.id, item_trade_id: item_trade.id)}

  it "購入評価と売却評価とアイテムトレードキューIDがある場合、有効である" do
    item_trade_detail = FactoryBot.build(:item_trade_detail, sale_popuarity: 0, buy_popuarity: 0, item_trade_queue_id: item_trade_queue.id)
    expect(item_trade_detail).to be_valid
  end

  it "アイテムトレードキューIDだけある場合、有効である" do
    item_trade_detail = FactoryBot.build(:item_trade_detail, sale_popuarity: nil, buy_popuarity: nil, item_trade_queue_id: item_trade_queue.id)
    expect(item_trade_detail).to be_valid
  end

  it "購入評価が3,0,-1以外の場合、無効である" do
    item_trade_detail = FactoryBot.build(:item_trade_detail, sale_popuarity: 0, buy_popuarity: 2, item_trade_queue_id: item_trade_queue.id)
    item_trade_detail.valid?
    expect(item_trade_detail.errors[:buy_popuarity]).to include("は一覧にありません")
  end

  it "売却評価が3,0,-1未満の場合、無効である" do
    item_trade_detail = FactoryBot.build(:item_trade_detail, sale_popuarity: -2, buy_popuarity: 0, item_trade_queue_id: item_trade_queue.id)
    item_trade_detail.valid?
    expect(item_trade_detail.errors[:sale_popuarity]).to include("は一覧にありません")
  end

  it "アイテムトレードキューIDがない場合、無効である" do
    item_trade_detail = FactoryBot.build(:item_trade_detail, sale_popuarity: 0, buy_popuarity: 0, item_trade_queue_id: nil)
    item_trade_detail.valid?
    expect(item_trade_detail.errors[:item_trade_queue_id]).to include("を入力してください")
  end
end
