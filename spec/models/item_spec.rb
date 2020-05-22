require 'rails_helper'

RSpec.describe Item, type: :model do
  let(:item_genre){FactoryBot.create(:item_genre)}
  let(:game){FactoryBot.create(:game)}
  it "名前とアイテムジャンルIDとゲームIDがある場合、有効である" do
    item = FactoryBot.build(:item, unit_name: nil, item_genre_id: item_genre.id, game_id: game.id)
    expect(item).to be_valid
  end

  it "名前がない場合、無効である" do
    item = FactoryBot.build(:item, name: nil, item_genre_id: item_genre.id, game_id: game.id)
    item.valid?
    expect(item.errors[:name]).to include("を入力してください")
  end

  it "名前が31文字以上の場合、無効である" do
    item = FactoryBot.build(:item, name: 'a' * 31, item_genre_id: item_genre.id, game_id: game.id)
    item.valid?
    expect(item.errors[:name]).to include("は30文字以内で入力してください")
  end

  it "単位名が11文字以上の場合、無効である" do
    item = FactoryBot.build(:item, unit_name: 'a' * 11, item_genre_id: item_genre.id, game_id: game.id)
    item.valid?
    expect(item.errors[:unit_name]).to include("は10文字以内で入力してください")
  end

  it "アイテムジャンルIDがない場合、無効である" do
    item = FactoryBot.build(:item, item_genre_id: nil, game_id: game.id)
    item.valid?
    expect(item.errors[:item_genre_id]).to include("を入力してください")
  end

  it "ゲームIDがない場合、無効である" do
    item = FactoryBot.build(:item, item_genre_id: item_genre.id, game_id: nil)
    item.valid?
    expect(item.errors[:game_id]).to include("を入力してください")
  end
end
