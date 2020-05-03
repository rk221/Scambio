require 'rails_helper'

RSpec.describe UserGameRank, type: :model do
  let!(:user){FactoryBot.create(:user)}
  let!(:game){FactoryBot.create(:game)}
  it "ユーザID、ゲームID、トレード回数、ランク、評判がある場合、有効である" do
    user_game_rank = FactoryBot.build(:user_game_rank, user_id: user.id, game_id: game.id)
    expect(user_game_rank).to be_valid
  end

  it "ユーザIDがない場合、無効にある" do
    user_game_rank = FactoryBot.build(:user_game_rank, user_id: nil, game_id: game.id)
    user_game_rank.valid?
    expect(user_game_rank.errors[:user_id]).to include("を入力してください")
  end

  it "ゲームIDがない場合、無効である" do
    user_game_rank = FactoryBot.build(:user_game_rank, user_id: user.id, game_id: nil)
    user_game_rank.valid?
    expect(user_game_rank.errors[:game_id]).to include("を入力してください")
  end

  it "ユーザIDとゲームIDごとで重複している場合、無効である" do
    FactoryBot.create(:user_game_rank, user_id: user.id, game_id: game.id)
    user_game_rank = FactoryBot.build(:user_game_rank, user_id: user.id, game_id: game.id)
    user_game_rank.valid?
    expect(user_game_rank.errors[:user_id]).to include("はすでに存在します")
  end

  it "ランクが-2未満の場合、無効である" do
    user_game_rank = FactoryBot.build(:user_game_rank, rank: -3, user_id: user.id, game_id: game.id)
    user_game_rank.valid?
    expect(user_game_rank.errors[:rank]).to include("は-2以上の値にしてください")
  end

  it "ランクが5以上の場合、無効である" do
    user_game_rank = FactoryBot.build(:user_game_rank, rank: 5, user_id: user.id, game_id: game.id)
    user_game_rank.valid?
    expect(user_game_rank.errors[:rank]).to include("は4以下の値にしてください")
  end

  it "トレード回数が0未満の場合、無効である" do
    user_game_rank = FactoryBot.build(:user_game_rank, trade_count: -1, user_id: user.id, game_id: game.id)
    user_game_rank.valid?
    expect(user_game_rank.errors[:trade_count]).to include("は0以上の値にしてください")
  end

  it "評判が-100未満の場合、無効である" do
    user_game_rank = FactoryBot.build(:user_game_rank, popularity: -101, user_id: user.id, game_id: game.id)
    user_game_rank.valid?
    expect(user_game_rank.errors[:popularity]).to include("は-100以上の値にしてください")
  end

  it "評判が101以上の場合、無効である" do
    user_game_rank = FactoryBot.build(:user_game_rank, popularity: 101, user_id: user.id, game_id: game.id)
    user_game_rank.valid?
    expect(user_game_rank.errors[:popularity]).to include("は100以下の値にしてください")
  end
end