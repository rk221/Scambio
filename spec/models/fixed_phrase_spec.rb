require 'rails_helper'

RSpec.describe FixedPhrase, type: :model do
  let(:user){FactoryBot.create(:user)}
  it "ユーザID、PSN_IDがある場合、有効である" do 
    fixed_phrase = FactoryBot.build(:fixed_phrase, user_id: user.id)
    expect(fixed_phrase).to be_valid
  end

  it "ユーザIDが無い場合、無効である" do
    fixed_phrase = FactoryBot.build(:fixed_phrase, user_id: nil)
    fixed_phrase.valid?
    expect(fixed_phrase.errors[:user_id]).to include("を入力してください") 
  end

  it "名前が無い場合、無効である" do
    fixed_phrase = FactoryBot.build(:fixed_phrase, name: nil, user_id: user.id)
    fixed_phrase.valid?
    expect(fixed_phrase.errors[:name]).to include("を入力してください") 
  end

  it "名前が31文字以上の場合、無効である" do
    fixed_phrase = FactoryBot.build(:fixed_phrase, name: 'a' * 31, user_id: user.id)
    fixed_phrase.valid?
    expect(fixed_phrase.errors[:name]).to include("は30文字以内で入力してください") 
  end

  it "文章が無い場合、無効である" do
    fixed_phrase = FactoryBot.build(:fixed_phrase, text: nil, user_id: user.id)
    fixed_phrase.valid?
    expect(fixed_phrase.errors[:text]).to include("を入力してください") 
  end

  it "文章が101文字以上の場合、無効である" do
    fixed_phrase = FactoryBot.build(:fixed_phrase, text: 'a' * 101, user_id: user.id)
    fixed_phrase.valid?
    expect(fixed_phrase.errors[:text]).to include("は100文字以内で入力してください") 
  end
end
