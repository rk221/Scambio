require 'rails_helper'

RSpec.describe ItemGenre, type: :model do
  it "is valid with valid attributes" do
    item_genre = build(:item_genre)
    expect(item_genre).to be_valid
  end

  it "is not valid without a name" do
    item_genre = build(:item_genre, name: nil)
    item_genre.valid?
    expect(item_genre.errors[:name]).to include("を入力してください")
  end

  it "is not valid with a 31 characters or more name" do
    item_genre = build(:item_genre, name: 'a' * 31)
    item_genre.valid?
    expect(item_genre.errors[:name]).to include("は30文字以内で入力してください")
  end

  it "is not valid with a not unique name" do
    create(:item_genre)
    item_genre = build(:item_genre)
    item_genre.valid?
    expect(item_genre.errors[:name]).to include("はすでに存在します")
  end

  it "is not valid without a default_unit_name" do
    item_genre = build(:item_genre, default_unit_name: nil)
    item_genre.valid?
    expect(item_genre.errors[:default_unit_name]).to include("を入力してください")
  end

  it "is not valid with a 11 characters or more default_unit_name" do
    item_genre = build(:item_genre, default_unit_name: 'a' * 11)
    item_genre.valid?
    expect(item_genre.errors[:default_unit_name]).to include("は10文字以内で入力してください")
  end
end
