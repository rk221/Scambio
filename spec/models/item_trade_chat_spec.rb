require 'rails_helper'

RSpec.describe ItemTradeChat, type: :model do
  let!(:user){create(:user)}
  let!(:item_genre){create(:item_genre)}
  let!(:game){create(:game)}
  let!(:buy_item){create(:buy_item, item_genre: item_genre, game: game)}
  let!(:sale_item){create(:sale_item, item_genre: item_genre, game: game)}
  let!(:user_game_rank){create(:user_game_rank, user: user, game: game)}
  let!(:item_trade){create(:item_trade, user: user, game: game, buy_item: buy_item, sale_item: sale_item, user_game_rank: user_game_rank)}
  let!(:item_trade_queue){create(:item_trade_queue, user: user, item_trade: item_trade)}
  let!(:item_trade_detail){create(:item_trade_detail, item_trade_queue: item_trade_queue)}

  it "is valid with valid attributes" do
    item_trade_chat = build(:item_trade_chat, sender_is_seller: true, item_trade_detail: item_trade_detail, message: 'テストメッセージ')
    expect(item_trade_chat).to be_valid
  end

  it "is not valid without a sender_is_seller" do
    item_trade_chat = build(:item_trade_chat, sender_is_seller: nil, item_trade_detail: item_trade_detail, message: 'テストメッセージ')
    item_trade_chat.valid?
    expect(item_trade_chat.errors[:sender_is_seller]).to include("は一覧にありません")
  end

  it "is not valid without an item_trade_detail_id" do
    item_trade_chat = build(:item_trade_chat, sender_is_seller: true, item_trade_detail: nil, message: 'テストメッセージ')
    item_trade_chat.valid?
    expect(item_trade_chat.errors[:item_trade_detail_id]).to include("を入力してください")
  end

  it "is not valid without message and image" do
    item_trade_chat = build(:item_trade_chat, sender_is_seller: true, item_trade_detail: item_trade_detail, message: nil, image: nil)
    item_trade_chat.valid?
    expect(item_trade_chat.errors[:message]).to include("object_null")
  end

  it "is not valid with a 201 characters or more message" do
    item_trade_chat = build(:item_trade_chat, sender_is_seller: true, item_trade_detail: item_trade_detail, message: "a" * 201)
    item_trade_chat.valid?
    expect(item_trade_chat.errors[:message]).to include("は200文字以内で入力してください")
  end
end
