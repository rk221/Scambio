require 'rails_helper'

RSpec.describe ItemTradeDetail, type: :model do
  let!(:user){FactoryBot.create(:user)}
  let!(:item_genre){FactoryBot.create(:item_genre)}
  let!(:game){FactoryBot.create(:game)}
  let!(:buy_item){FactoryBot.create(:buy_item, item_genre_id: item_genre.id, game_id: game.id)}
  let!(:sale_item){FactoryBot.create(:sale_item, item_genre_id: item_genre.id, game_id: game.id)}
  let!(:item_trade){FactoryBot.create(:item_trade, user_id: user.id, game_id: game.id, buy_item_id: buy_item.id, sale_item_id: sale_item.id)}
  
  it "購入評価と売却評価と購入ユーザIDとアイテムトレードIDがある場合、有効である" do
    item_trade_detail = FactoryBot.build(:item_trade_detail, buy_user_id: user.id, item_trade_id: item_trade.id)
    expect(item_trade_detail).to be_valid
  end

  it "購入評価がない場合、無効である" do
    item_trade_detail = FactoryBot.build(:item_trade_detail, buy_user_popuarity: nil, buy_user_id: user.id, item_trade_id: item_trade.id)
    item_trade_detail.valid?
    expect(item_trade_detail.errors[:buy_user_popuarity]).to include("を入力してください")
  end

  it "売却評価がない場合、無効である" do
    item_trade_detail = FactoryBot.build(:item_trade_detail, sale_user_popuarity: nil, buy_user_id: user.id, item_trade_id: item_trade.id)
    item_trade_detail.valid?
    expect(item_trade_detail.errors[:sale_user_popuarity]).to include("を入力してください")
  end

  it "購入ユーザIDがない場合、無効である" do
    item_trade_detail = FactoryBot.build(:item_trade_detail, buy_user_id: nil, item_trade_id: item_trade.id)
    item_trade_detail.valid?
    expect(item_trade_detail.errors[:buy_user_id]).to include("を入力してください")
  end

  it "アイテムトレードIDがない場合、無効である" do
    item_trade_detail = FactoryBot.build(:item_trade_detail, buy_user_id: user.id, item_trade_id: nil)
    item_trade_detail.valid?
    expect(item_trade_detail.errors[:item_trade_id]).to include("を入力してください")
  end
end
