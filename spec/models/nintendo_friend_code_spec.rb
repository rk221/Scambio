require 'rails_helper'

RSpec.describe NintendoFriendCode, type: :model do
  let(:user){FactoryBot.create(:user)}
  it "ユーザID、フレンドコードがある場合、有効である" do 
    nintendo_friend_code = FactoryBot.build(:nintendo_friend_code, user_id: user.id)
    expect(nintendo_friend_code).to be_valid
  end

  it "ユーザIDが無い場合、無効である" do
    nintendo_friend_code = FactoryBot.build(:nintendo_friend_code, user_id: nil)
    nintendo_friend_code.valid?
    expect(nintendo_friend_code.errors[:user_id]).to include("を入力してください") 
  end

  it "ユーザIDが重複している場合、無効である" do
    FactoryBot.create(:nintendo_friend_code, user_id: user.id)
    nintendo_friend_code = FactoryBot.build(:nintendo_friend_code, user_id: user.id)
    nintendo_friend_code.valid?
    expect(nintendo_friend_code.errors[:user_id]).to include("はすでに存在します") 
  end

  it "フレンドコードが無い場合、無効である" do
    nintendo_friend_code = FactoryBot.build(:nintendo_friend_code, friend_code: nil, user_id: user.id)
    nintendo_friend_code.valid?
    expect(nintendo_friend_code.errors[:friend_code]).to include("を入力してください") 
  end

  it "フレンドコードが使用出来ない値の場合、無効である" do
    nintendo_friend_code = FactoryBot.build(:nintendo_friend_code, friend_code: 'abcdefghijkl', user_id: user.id)
    nintendo_friend_code.valid?
    expect(nintendo_friend_code.errors[:friend_code]).to include("は数値で入力してください") 
  end

  it "フレンドコードが12桁では無い場合、無効である" do
    nintendo_friend_code = FactoryBot.build(:nintendo_friend_code, friend_code: '1234567890123', user_id: user.id)
    nintendo_friend_code.valid?
    expect(nintendo_friend_code.errors[:friend_code]).to include("は12文字で入力してください") 
  end
end
