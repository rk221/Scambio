require 'rails_helper'

RSpec.describe UserBadge, type: :model do
  let!(:user){create(:user)}
  let!(:game){create(:game)}
  let!(:badge){create(:badge, game: game)}

  it "is valid with valid attributes" do
    user_badge = build(:user_badge, user: user, badge: badge)
    expect(user_badge).to be_valid
  end

  it "is not valid without an user_id" do
    user_badge = build(:user_badge, user: nil, badge: badge)
    user_badge.valid?
    expect(user_badge.errors[:user_id]).to include("を入力してください")
  end

  it "is not valid without a badge_id" do
    user_badge = build(:user_badge, user: user, badge: nil)
    user_badge.valid?
    expect(user_badge.errors[:badge_id]).to include("を入力してください")
  end

  it "is not valid with not unique conbination user_id and badge_id" do
    create(:user_badge, user: user, badge: badge)
    user_badge = build(:user_badge, user: user, badge: badge)
    user_badge.valid?
    expect(user_badge.errors[:user_id]).to include("はすでに存在します")
  end

  it "is not valid without an wear" do
    user_badge = build(:user_badge, wear: nil, user: user, badge: badge)
    user_badge.valid?
    expect(user_badge.errors[:wear]).to include("は一覧にありません")
  end
end
