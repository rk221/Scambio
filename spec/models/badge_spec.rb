require 'rails_helper'

RSpec.describe Badge, type: :model do
  let!(:game){create(:game)}
  it "is valid with valid attributes" do
    badge = build(:badge, game: game)
    expect(badge).to be_valid
  end

  it "is not valid without a game_id" do
    badge = build(:badge, game: nil)
    badge.valid?
    expect(badge.errors[:game_id]).to include("を入力してください") 
  end

  it "is not valid with a 31 characters or more name" do
    badge = build(:badge, name: 'a' * 31, game: game)
    badge.valid?
    expect(badge.errors[:name]).to include("は30文字以内で入力してください")
  end

  it "is not valid with a not unique conbination name and game_id" do
    create(:badge, game: game)
    badge = build(:badge, game: game)
    badge.valid?
    expect(badge.errors[:game_id]).to include("はすでに存在します")
  end

  it "is not valid without a item_trade_count_condition" do
    badge = build(:badge, item_trade_count_condition: nil, game: game)
    badge.valid?
    expect(badge.errors[:item_trade_count_condition]).to include("を入力してください") 
  end

  it "is not valid with a 1 less than item_trade_count_condition" do
    badge = build(:badge, item_trade_count_condition: -1, game: game)
    badge.valid?
    expect(badge.errors[:item_trade_count_condition]).to include("は1以上の値にしてください")
  end

  it "is not valid without a rank_condition" do
    badge = build(:badge, rank_condition: nil, game: game)
    badge.valid?
    expect(badge.errors[:rank_condition]).to include("を入力してください") 
  end

  it "is not valid with a -2 less than rank_condition" do
    badge = build(:badge, rank_condition: -3, game: game)
    badge.valid?
    expect(badge.errors[:rank_condition]).to include("は-2以上の値にしてください")
  end

  it "is not valid with a 4 greater than rank_condition" do
    badge = build(:badge, rank_condition: 5, game: game)
    badge.valid?
    expect(badge.errors[:rank_condition]).to include("は4以下の値にしてください")
  end
  
  it "is not valid with a 201 characters or more description" do
    badge = build(:badge, description: 'a' * 201, game: game)
    badge.valid?
    expect(badge.errors[:description]).to include("は200文字以内で入力してください")
  end
end
