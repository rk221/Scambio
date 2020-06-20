require 'rails_helper'

RSpec.describe ItemTradeChat, type: :model do
  let!(:user){FactoryBot.create(:user)}
  let!(:item_genre){FactoryBot.create(:item_genre)}
  let!(:game){FactoryBot.create(:game)}
  let!(:buy_item){FactoryBot.create(:buy_item, item_genre_id: item_genre.id, game_id: game.id)}
  let!(:sale_item){FactoryBot.create(:sale_item, item_genre_id: item_genre.id, game_id: game.id)}
  let!(:item_trade){FactoryBot.create(:item_trade, user_id: user.id, game_id: game.id, buy_item_id: buy_item.id, sale_item_id: sale_item.id)}
  let!(:item_trade_queue){FactoryBot.create(:item_trade_queue, user_id: user.id, item_trade_id: item_trade.id)}
  let!(:item_trade_detail){FactoryBot.create(:item_trade_detail, item_trade_queue_id: item_trade_queue.id)}

  it "送信者フラグとアイテムトレード明細IDとメッセージがある場合、有効である" do
    item_trade_chat = FactoryBot.build(:item_trade_chat, sender_is_seller: true, item_trade_detail_id: item_trade_detail.id, message: 'テストメッセージ')
    expect(item_trade_chat).to be_valid
  end

  it "送信者フラグがない場合、無効である" do
    item_trade_chat = FactoryBot.build(:item_trade_chat, sender_is_seller: nil, item_trade_detail_id: item_trade_detail.id, message: 'テストメッセージ')
    item_trade_chat.valid?
    expect(item_trade_chat.errors[:sender_is_seller]).to include("は一覧にありません")
  end

  it "アイテムトレード明細IDがない場合、無効である" do
    item_trade_chat = FactoryBot.build(:item_trade_chat, sender_is_seller: true, item_trade_detail_id: nil, message: 'テストメッセージ')
    item_trade_chat.valid?
    expect(item_trade_chat.errors[:item_trade_detail_id]).to include("を入力してください")
  end

  it "メッセージが201文字以上の場合、無効である" do
    item_trade_chat = FactoryBot.build(:item_trade_chat, sender_is_seller: true, item_trade_detail_id: item_trade_detail.id, message: "a" * 201)
    item_trade_chat.valid?
    expect(item_trade_chat.errors[:message]).to include("は200文字以内で入力してください")
  end
end
