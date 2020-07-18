require 'rails_helper'

RSpec.describe ItemTrade, type: :model do
  let!(:user){create(:user)}
  let!(:item_genre){create(:item_genre)}
  let!(:game){create(:game)}
  let!(:buy_item){create(:buy_item, item_genre: item_genre, game: game)}
  let!(:sale_item){create(:sale_item, item_genre: item_genre, game: game)}
  let!(:user_game_rank){create(:user_game_rank, user: user, game: game)}

  it "is valid with valid attributes" do
    item_trade = build(:item_trade, user: user, game: game, buy_item: buy_item, sale_item: sale_item, user_game_rank: user_game_rank)
    expect(item_trade).to be_valid
  end

  it "is not valid without an user_id" do
    item_trade = build(:item_trade, user: nil, game: game, buy_item: buy_item, sale_item: sale_item, user_game_rank: user_game_rank)
    item_trade.valid?
    expect(item_trade.errors[:user_id]).to include("を入力してください")
  end

  it "is not valid without a game_id" do
    item_trade = build(:item_trade, user: user, game: nil, buy_item: buy_item, sale_item: sale_item, user_game_rank: user_game_rank)
    item_trade.valid?
    expect(item_trade.errors[:game_id]).to include("を入力してください")
  end

  it "is not valid without a buy_item_id" do
    item_trade = build(:item_trade, user: user, game: game, buy_item: nil, sale_item: sale_item, user_game_rank: user_game_rank)
    item_trade.valid?
    expect(item_trade.errors[:buy_item_id]).to include("を入力してください")
  end

  it "is not valid without a sale_item_id" do
    item_trade = build(:item_trade, user: user, game: game, buy_item: buy_item, sale_item: nil, user_game_rank: user_game_rank)
    item_trade.valid?
    expect(item_trade.errors[:sale_item_id]).to include("を入力してください")
  end

  it "is not valid without a buy_item_quantity" do
    item_trade = build(:item_trade, buy_item_quantity: nil, user: user, game: game, buy_item: buy_item, sale_item: sale_item, user_game_rank: user_game_rank)
    item_trade.valid?
    expect(item_trade.errors[:buy_item_quantity]).to include("を入力してください")
  end

  it "is not valid with a 0 less than buy_item_quantity" do
    item_trade = build(:item_trade, buy_item_quantity: 0, user: user, game: game, buy_item: buy_item, sale_item: sale_item, user_game_rank: user_game_rank)
    item_trade.valid?
    expect(item_trade.errors[:buy_item_quantity]).to include("は1以上の値にしてください")
  end

  it "is not valid without a sale_item_quantity" do
    item_trade = build(:item_trade, sale_item_quantity: nil, user: user, game: game, buy_item: buy_item, sale_item: sale_item, user_game_rank: user_game_rank)
    item_trade.valid?
    expect(item_trade.errors[:sale_item_quantity]).to include("を入力してください")
  end

  it "is not valid with a 0 less than sale_item_quantity" do
    item_trade = build(:item_trade, sale_item_quantity: 0, user: user, game: game, buy_item: buy_item, sale_item: sale_item, user_game_rank: user_game_rank)
    item_trade.valid?
    expect(item_trade.errors[:sale_item_quantity]).to include("は1以上の値にしてください")
  end

  it "is not valid without an enable" do
    item_trade = build(:item_trade, enable: nil, user: user, game: game, buy_item: buy_item, sale_item: sale_item, user_game_rank: user_game_rank)
    item_trade.valid?
    expect(item_trade.errors[:enable]).to include("は一覧にありません")
  end

  it "is not valid without a numeric_of_trade_deadline" do
    item_trade = build(:item_trade, numeric_of_trade_deadline: nil, user: user, game: game, buy_item: buy_item, sale_item: sale_item, user_game_rank: user_game_rank)
    item_trade.valid?
    expect(item_trade.errors[:trade_deadline]).to include("を入力してください")
  end

  it "is not valid without an user_game_rank_id" do
    item_trade = build(:item_trade, user: user, game: game, buy_item: buy_item, sale_item: sale_item, user_game_rank: nil)
    item_trade.valid?
    expect(item_trade.errors[:user_game_rank_id]).to include("を入力してください")
  end
end
