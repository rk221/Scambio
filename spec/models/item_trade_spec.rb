require 'rails_helper'

RSpec.describe ItemTrade, type: :model do
  let!(:user){FactoryBot.create(:user)}
  let!(:item_genre){FactoryBot.create(:item_genre)}
  let!(:game){FactoryBot.create(:game)}
  let!(:buy_item){FactoryBot.create(:buy_item, item_genre_id: item_genre.id, game_id: game.id)}
  let!(:sale_item){FactoryBot.create(:sale_item, item_genre_id: item_genre.id, game_id: game.id)}
  let!(:user_game_rank){FactoryBot.create(:user_game_rank, user_id: user.id, game_id: game.id)}

  it "ユーザIDとゲームIDと購入アイテムIDと購入数量と売却アイテムがIDと売却数量と有効化フラグと取引期限とユーザゲームランクIDがある場合、有効である" do
    item_trade = FactoryBot.build(:item_trade, user_id: user.id, game_id: game.id, buy_item_id: buy_item.id, sale_item_id: sale_item.id, user_game_rank_id: user_game_rank.id)
    expect(item_trade).to be_valid
  end

  it "ユーザIDがない場合、無効である" do
    item_trade = FactoryBot.build(:item_trade, user_id: nil, game_id: game.id, buy_item_id: buy_item.id, sale_item_id: sale_item.id, user_game_rank_id: user_game_rank.id)
    item_trade.valid?
    expect(item_trade.errors[:user_id]).to include("を入力してください")
  end

  it "ゲームIDがない場合、無効である" do
    item_trade = FactoryBot.build(:item_trade, user_id: user.id, game_id: nil, buy_item_id: buy_item.id, sale_item_id: sale_item.id, user_game_rank_id: user_game_rank.id)
    item_trade.valid?
    expect(item_trade.errors[:game_id]).to include("を入力してください")
  end

  it "購入アイテムIDがない場合、無効である" do
    item_trade = FactoryBot.build(:item_trade, user_id: user.id, game_id: game.id, buy_item_id: nil, sale_item_id: sale_item.id, user_game_rank_id: user_game_rank.id)
    item_trade.valid?
    expect(item_trade.errors[:buy_item_id]).to include("を入力してください")
  end

  it "売却アイテムIDがない場合、無効である" do
    item_trade = FactoryBot.build(:item_trade, user_id: user.id, game_id: game.id, buy_item_id: buy_item.id, sale_item_id: nil, user_game_rank_id: user_game_rank.id)
    item_trade.valid?
    expect(item_trade.errors[:sale_item_id]).to include("を入力してください")
  end

  it "購入数量がない場合、無効である" do
    item_trade = FactoryBot.build(:item_trade, buy_item_quantity: nil, user_id: user.id, game_id: game.id, buy_item_id: buy_item.id, sale_item_id: sale_item.id, user_game_rank_id: user_game_rank.id)
    item_trade.valid?
    expect(item_trade.errors[:buy_item_quantity]).to include("を入力してください")
  end

  it "購入数量が0以下の場合、無効である" do
    item_trade = FactoryBot.build(:item_trade, buy_item_quantity: 0, user_id: user.id, game_id: game.id, buy_item_id: buy_item.id, sale_item_id: sale_item.id, user_game_rank_id: user_game_rank.id)
    item_trade.valid?
    expect(item_trade.errors[:buy_item_quantity]).to include("は1以上の値にしてください")
  end


  it "売却数量がない場合、無効である" do
    item_trade = FactoryBot.build(:item_trade, sale_item_quantity: nil, user_id: user.id, game_id: game.id, buy_item_id: buy_item.id, sale_item_id: sale_item.id, user_game_rank_id: user_game_rank.id)
    item_trade.valid?
    expect(item_trade.errors[:sale_item_quantity]).to include("を入力してください")
  end

  it "売却数量が0以下の場合、無効である" do
    item_trade = FactoryBot.build(:item_trade, sale_item_quantity: 0, user_id: user.id, game_id: game.id, buy_item_id: buy_item.id, sale_item_id: sale_item.id, user_game_rank_id: user_game_rank.id)
    item_trade.valid?
    expect(item_trade.errors[:sale_item_quantity]).to include("は1以上の値にしてください")
  end

  it "有効化フラグがない場合、無効である" do
    item_trade = FactoryBot.build(:item_trade, enable_flag: nil, user_id: user.id, game_id: game.id, buy_item_id: buy_item.id, sale_item_id: sale_item.id, user_game_rank_id: user_game_rank.id)
    item_trade.valid?
    expect(item_trade.errors[:enable_flag]).to include("は一覧にありません")
  end

  it "取引期限がない場合、無効である" do
    item_trade = FactoryBot.build(:item_trade, numeric_of_trade_deadline: nil, user_id: user.id, game_id: game.id, buy_item_id: buy_item.id, sale_item_id: sale_item.id, user_game_rank_id: user_game_rank.id)
    item_trade.valid?
    expect(item_trade.errors[:trade_deadline]).to include("を入力してください")
  end

  it "ユーザゲームランクIDがない場合、無効である" do
    item_trade = FactoryBot.build(:item_trade, user_id: user.id, game_id: game.id, buy_item_id: buy_item.id, sale_item_id: sale_item.id, user_game_rank_id: nil)
    item_trade.valid?
    expect(item_trade.errors[:user_game_rank_id]).to include("を入力してください")
  end
end
