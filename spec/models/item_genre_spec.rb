require 'rails_helper'

RSpec.describe ItemGenre, type: :model do
  it "名前とデフォルトの単位名がある場合、有効である" do
    item_genre = FactoryBot.build(:item_genre)
    expect(item_genre).to be_valid
  end

  it "名前がない場合、無効である" do
    item_genre = FactoryBot.build(:item_genre, name: nil)
    item_genre.valid?
    expect(item_genre.errors[:name]).to include("を入力してください")
  end

  it "名前が31文字以上の場合、無効である" do
    item_genre = FactoryBot.build(:item_genre, name: 'a' * 31)
    item_genre.valid?
    expect(item_genre.errors[:name]).to include("は30文字以内で入力してください")
  end

  it "名前が重複している場合、無効である" do
    FactoryBot.create(:item_genre)
    item_genre = FactoryBot.build(:item_genre)
    item_genre.valid?
    expect(item_genre.errors[:name]).to include("はすでに存在します")
  end

  it "デフォルトの単位名がない場合、無効である" do
    item_genre = FactoryBot.build(:item_genre, default_unit_name: nil)
    item_genre.valid?
    expect(item_genre.errors[:default_unit_name]).to include("を入力してください")
  end

  it "デフォルトの単位名が11文字以上の場合、無効である" do
    item_genre = FactoryBot.build(:item_genre, default_unit_name: 'a' * 11)
    item_genre.valid?
    expect(item_genre.errors[:default_unit_name]).to include("は10文字以内で入力してください")
  end
end
