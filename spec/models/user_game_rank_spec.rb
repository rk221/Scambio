require 'rails_helper'

RSpec.describe UserGameRank, type: :model do
  let!(:user){create(:user)}
  let!(:game){create(:game)}
  it "is valid with valid attributes" do
    user_game_rank = build(:user_game_rank, user: user, game: game)
    expect(user_game_rank).to be_valid
  end

  it "is not valid without an user_id" do
    user_game_rank = build(:user_game_rank, user: nil, game: game)
    user_game_rank.valid?
    expect(user_game_rank.errors[:user_id]).to include("を入力してください")
  end

  it "is not valid without a game_id" do
    user_game_rank = build(:user_game_rank, user: user, game: nil)
    user_game_rank.valid?
    expect(user_game_rank.errors[:game_id]).to include("を入力してください")
  end

  it "is not valid with not unique conbination user_id and game_id" do
    create(:user_game_rank, user: user, game: game)
    user_game_rank = build(:user_game_rank, user: user, game: game)
    user_game_rank.valid?
    expect(user_game_rank.errors[:user_id]).to include("はすでに存在します")
  end

  it "is not valid with a -2 less than rank" do
    user_game_rank = build(:user_game_rank, rank: -3, user: user, game: game)
    user_game_rank.valid?
    expect(user_game_rank.errors[:rank]).to include("は-2以上の値にしてください")
  end

  it "is not valid with a 4 greater than rank" do
    user_game_rank = build(:user_game_rank, rank: 5, user: user, game: game)
    user_game_rank.valid?
    expect(user_game_rank.errors[:rank]).to include("は4以下の値にしてください")
  end

  it "is not valid with a 0 less than buy_trade_count" do
    user_game_rank = build(:user_game_rank, buy_trade_count: -1, user: user, game: game)
    user_game_rank.valid?
    expect(user_game_rank.errors[:buy_trade_count]).to include("は0以上の値にしてください")
  end

  it "is not valid with a 0 less than sale_trade_count" do
    user_game_rank = build(:user_game_rank, sale_trade_count: -1, user: user, game: game)
    user_game_rank.valid?
    expect(user_game_rank.errors[:sale_trade_count]).to include("は0以上の値にしてください")
  end

  it "is not valid with a -100 less than popularity" do
    user_game_rank = build(:user_game_rank, popularity: -101, user: user, game: game)
    user_game_rank.valid?
    expect(user_game_rank.errors[:popularity]).to include("は-100以上の値にしてください")
  end

  it "is not valid with a 100 greater than popularity" do
    user_game_rank = build(:user_game_rank, popularity: 101, user: user, game: game)
    user_game_rank.valid?
    expect(user_game_rank.errors[:popularity]).to include("は100以下の値にしてください")
  end
end