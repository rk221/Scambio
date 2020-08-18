require 'rails_helper'

RSpec.describe ItemTradeDetail, type: :model do
  let!(:user){create(:user)}
  let!(:item_genre){create(:item_genre)}
  let!(:game){create(:game)}
  let!(:buy_item){create(:buy_item, item_genre: item_genre, game: game)}
  let!(:sale_item){create(:sale_item, item_genre: item_genre, game: game)}
  let!(:user_game_rank){create(:user_game_rank, user: user, game: game)}
  let!(:item_trade){create(:item_trade, user: user, game: game, buy_item: buy_item, sale_item: sale_item, user_game_rank: user_game_rank)}
  let!(:item_trade_queue){create(:item_trade_queue, user: user, item_trade: item_trade)}

  it "is valid with valid attributes" do
    item_trade_detail = build(:item_trade_detail, sale_popuarity: 0, buy_popuarity: 0, item_trade: item_trade, item_trade_queue: item_trade_queue)
    expect(item_trade_detail).to be_valid
  end

  it "is valid with an item_trade_queue_id" do
    item_trade_detail = build(:item_trade_detail, sale_popuarity: nil, buy_popuarity: nil, item_trade: item_trade, item_trade_queue: item_trade_queue)
    expect(item_trade_detail).to be_valid
  end

  it "is not valid without an item_trade_queue_id" do
    item_trade_detail = build(:item_trade_detail, sale_popuarity: 0, buy_popuarity: 0, item_trade: item_trade, item_trade_queue: nil)
    item_trade_detail.valid?
    expect(item_trade_detail.errors[:item_trade_queue_id]).to include("を入力してください")
  end

  it "is valid without an item_trade_queue_id on update" do
    item_trade_detail = create(:item_trade_detail, sale_popuarity: nil, buy_popuarity: nil, item_trade: item_trade, item_trade_queue: item_trade_queue)
    item_trade_detail.update(item_trade_queue_id: nil)
    expect(item_trade_detail.reload.item_trade_queue_id).to eq(nil)
  end

  it "is not valid with an other than 3 and 0 and -1 buy_popuarity" do
    item_trade_detail = build(:item_trade_detail, sale_popuarity: 0, buy_popuarity: 2, item_trade: item_trade, item_trade_queue: item_trade_queue)
    item_trade_detail.valid?
    expect(item_trade_detail.errors[:buy_popuarity]).to include("は一覧にありません")
  end

  it "is not valid with an other than 3 and 0 and -1 sale_popuarity" do
    item_trade_detail = build(:item_trade_detail, sale_popuarity: -2, buy_popuarity: 0, item_trade: item_trade, item_trade_queue: item_trade_queue)
    item_trade_detail.valid?
    expect(item_trade_detail.errors[:sale_popuarity]).to include("は一覧にありません")
  end

  it "is not valid without an item_trade_id" do
    item_trade_detail = build(:item_trade_detail, sale_popuarity: 0, buy_popuarity: 0, item_trade: nil)
    item_trade_detail.valid?
    expect(item_trade_detail.errors[:item_trade_id]).to include("を入力してください")
  end
end
