require 'rails_helper'

RSpec.describe ItemGenreGame, type: :model do
  let(:item_genre){create(:item_genre)}
  let(:game){create(:game)}

  it "is valid with valid attributes" do
    item_genre_game = build(:item_genre_game, item_genre: item_genre, game: game, enable: false)
    expect(item_genre_game).to be_valid
  end

  it "is not valid without an item_genre_id" do
    item_genre_game = build(:item_genre_game, item_genre: nil, game: game)
    item_genre_game.valid?
    expect(item_genre_game.errors[:item_genre_id]).to include("を入力してください")
  end

  it "is not valid without a game_id" do
    item_genre_game = build(:item_genre_game, item_genre: item_genre, game: nil)
    item_genre_game.valid?
    expect(item_genre_game.errors[:game_id]).to include("を入力してください")
  end

  it "is not valid with not unique conbination user_id and game_id" do
    create(:item_genre_game, item_genre: item_genre, game: game)
    item_genre_game = build(:item_genre_game, item_genre: item_genre, game: game)
    item_genre_game.valid?
    expect(item_genre_game.errors[:item_genre_id]).to include("はすでに存在します")
  end

  it "is not valid without a enable" do
    item_genre_game = build(:item_genre_game, enable: nil, item_genre: item_genre, game: game)
    item_genre_game.valid?
    expect(item_genre_game.errors[:enable]).to include("は一覧にありません")
  end
end
