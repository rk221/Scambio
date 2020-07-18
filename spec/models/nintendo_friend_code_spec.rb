require 'rails_helper'

RSpec.describe NintendoFriendCode, type: :model do
  let(:user){create(:user)}
  it "is valid with valid attributes" do
    nintendo_friend_code = build(:nintendo_friend_code, user: user)
    expect(nintendo_friend_code).to be_valid
  end

  it "is not valid without an user_id" do
    nintendo_friend_code = build(:nintendo_friend_code, user: nil)
    nintendo_friend_code.valid?
    expect(nintendo_friend_code.errors[:user_id]).to include("を入力してください") 
  end

  it "is not valid with a not unique user_id" do
    create(:nintendo_friend_code, user: user)
    nintendo_friend_code = build(:nintendo_friend_code, user: user)
    nintendo_friend_code.valid?
    expect(nintendo_friend_code.errors[:user_id]).to include("はすでに存在します") 
  end

  it "is not valid without a friend_code" do
    nintendo_friend_code = build(:nintendo_friend_code, friend_code: nil, user: user)
    nintendo_friend_code.valid?
    expect(nintendo_friend_code.errors[:friend_code]).to include("を入力してください") 
  end

  it "is not valid with an invalid format friend_code" do
    nintendo_friend_code = build(:nintendo_friend_code, friend_code: 'abcdefghijkl', user: user)
    nintendo_friend_code.valid?
    expect(nintendo_friend_code.errors[:friend_code]).to include("は数値で入力してください") 
  end

  it "is not valid with a not 12 characters friend_code" do
    nintendo_friend_code = build(:nintendo_friend_code, friend_code: '1234567890123', user: user)
    nintendo_friend_code.valid?
    expect(nintendo_friend_code.errors[:friend_code]).to include("は12文字で入力してください") 
  end
end
