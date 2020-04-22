require 'rails_helper'

RSpec.describe User, type: :model do

  it "姓、名、ニックネーム、Eメール、パスワードがある場合、有効である" do
    user = FactoryBot.build(:user)
    expect(user).to be_valid
  end

  it "姓がない場合、無効である" do
    user = FactoryBot.build(:user, firstname: nil)
    user.valid?
    expect(user.errors[:firstname]).to include("を入力してください")
  end

  it "姓がカタカナな場合、無効である" do
    user = FactoryBot.build(:user, firstname: "カタカナ")
    user.valid?
    expect(user.errors[:firstname]).to include("は不正な値です")
  end

  it "姓がアルファベットな場合、無効である" do
    user = FactoryBot.build(:user, firstname: "name")
    user.valid?
    expect(user.errors[:firstname]).to include("は不正な値です")
  end

  it "名がない場合、無効である" do
    user = FactoryBot.build(:user, lastname: nil)
    user.valid?
    expect(user.errors[:lastname]).to include("を入力してください")
  end

  it "名がカタカナな場合、無効である" do
    user = FactoryBot.build(:user, lastname: "カタカナ")
    user.valid?
    expect(user.errors[:lastname]).to include("は不正な値です")
  end

  it "名がアルファベットな場合、無効である" do
    user = FactoryBot.build(:user, lastname: "name")
    user.valid?
    expect(user.errors[:lastname]).to include("は不正な値です")
  end

  it "ニックネームがない場合、無効である" do
    user = FactoryBot.build(:user, nickname: nil)
    user.valid?
    expect(user.errors[:nickname]).to include("を入力してください")
  end

  it "ニックネームが3文字以下の場合、無効である" do
    user = FactoryBot.build(:user, nickname: 'a' * 3)
    user.valid?
    expect(user.errors[:nickname]).to include("は4文字以上で入力してください")
  end

  it "ニックネームが31文字以上の場合、無効である" do
    user = FactoryBot.build(:user, nickname: 'a' * 31)
    user.valid?
    expect(user.errors[:nickname]).to include("は30文字以内で入力してください")
  end

  it "Eメールがない場合、無効である" do
    user = FactoryBot.build(:user, email: nil)
    user.valid?
    expect(user.errors[:email]).to include("を入力してください")
  end

  it "Eメールが使用できない文字列の場合、無効である" do
    user = FactoryBot.build(:user, email: 'emailcom')
    user.valid?
    expect(user.errors[:email]).to include("は不正な値です")
  end

  it "パスワードがない場合、無効である" do
    user = FactoryBot.build(:user, password: nil)
    user.valid?
    expect(user.errors[:password]).to include("を入力してください")
  end

  it "パスワードが129文字以上の場合、無効である" do
    user = FactoryBot.build(:user, password: 'a' * 129)
    user.valid?
    expect(user.errors[:password]).to include("は128文字以内で入力してください")
  end

  it "パスワードが7文字以下の場合、無効である" do
    user = FactoryBot.build(:user, password: 'a' * 7)
    user.valid?
    expect(user.errors[:password]).to include("は8文字以上で入力してください")
  end

end
