require 'rails_helper'

RSpec.describe ItemGenreGame, type: :model do
  let(:item_genre){FactoryBot.create(:item_genre)}
  let(:game){FactoryBot.create(:game)}
  it "アイテムジャンルIDとゲームIDと有効化フラグがある場合、有効である" do
    item_genre_game = FactoryBot.build(:item_genre_game, item_genre_id: item_genre.id, game_id: game.id, enable: false)
    expect(item_genre_game).to be_valid
  end

  it "アイテムジャンルIDがない場合、無効である" do
    item_genre_game = FactoryBot.build(:item_genre_game, item_genre_id: nil, game_id: game.id)
    item_genre_game.valid?
    expect(item_genre_game.errors[:item_genre_id]).to include("を入力してください")
  end

  it "ゲームIDがない場合、無効である" do
    item_genre_game = FactoryBot.build(:item_genre_game, item_genre_id: item_genre.id, game_id: nil)
    item_genre_game.valid?
    expect(item_genre_game.errors[:game_id]).to include("を入力してください")
  end

  it "アイテムジャンルIDとゲームIDごとで重複している場合、無効である" do
    FactoryBot.create(:item_genre_game, item_genre_id: item_genre.id, game_id: game.id)
    item_genre_game = FactoryBot.build(:item_genre_game, item_genre_id: item_genre.id, game_id: game.id)
    item_genre_game.valid?
    expect(item_genre_game.errors[:item_genre_id]).to include("はすでに存在します")
  end

  it "有効化フラグがない場合、無効である" do
    item_genre_game = FactoryBot.build(:item_genre_game, enable: nil, item_genre_id: item_genre.id, game_id: game.id)
    item_genre_game.valid?
    expect(item_genre_game.errors[:enable]).to include("は一覧にありません")
  end
end
