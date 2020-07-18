require 'rails_helper'

RSpec.describe Item, type: :model do
  let(:item_genre){create(:item_genre)}
  let(:game){create(:game)}

  it "is valid with valid attributes" do
    item = build(:item, unit_name: nil, item_genre: item_genre, game: game)
    expect(item).to be_valid
  end

  it "is not valid without a name" do
    item = build(:item, name: nil, item_genre: item_genre, game: game)
    item.valid?
    expect(item.errors[:name]).to include("を入力してください")
  end

  it "is not valid with a 31 characters or more name" do
    item = build(:item, name: 'a' * 31, item_genre: item_genre, game: game)
    item.valid?
    expect(item.errors[:name]).to include("は30文字以内で入力してください")
  end

  it "is not valid with a 11 characters or more unit_name" do
    item = build(:item, unit_name: 'a' * 11, item_genre: item_genre, game: game)
    item.valid?
    expect(item.errors[:unit_name]).to include("は10文字以内で入力してください")
  end

  it "is not valid without an item_genre_id" do
    item = build(:item, item_genre: nil, game: game)
    item.valid?
    expect(item.errors[:item_genre_id]).to include("を入力してください")
  end

  it "is not valid without a game_id" do
    item = build(:item, item_genre: item_genre, game: nil)
    item.valid?
    expect(item.errors[:game_id]).to include("を入力してください")
  end
end
