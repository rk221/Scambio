require 'rails_helper'

RSpec.describe FixedPhrase, type: :model do
  let(:user){create(:user)}
  it "is valid with valid attributes" do
    fixed_phrase = build(:fixed_phrase, user: user)
    expect(fixed_phrase).to be_valid
  end

  it "is not valid without an user_id" do
    fixed_phrase = build(:fixed_phrase, user: nil)
    fixed_phrase.valid?
    expect(fixed_phrase.errors[:user_id]).to include("を入力してください") 
  end

  it "is not valid without a name" do
    fixed_phrase = build(:fixed_phrase, name: nil, user: user)
    fixed_phrase.valid?
    expect(fixed_phrase.errors[:name]).to include("を入力してください") 
  end

  it "is not valid with a 31 characters or more name" do
    fixed_phrase = build(:fixed_phrase, name: 'a' * 31, user: user)
    fixed_phrase.valid?
    expect(fixed_phrase.errors[:name]).to include("は30文字以内で入力してください") 
  end

  it "is not valid without a text" do
    fixed_phrase = build(:fixed_phrase, text: nil, user: user)
    fixed_phrase.valid?
    expect(fixed_phrase.errors[:text]).to include("を入力してください") 
  end

  it "is not valid with a 101 characters or more text" do
    fixed_phrase = build(:fixed_phrase, text: 'a' * 101, user: user)
    fixed_phrase.valid?
    expect(fixed_phrase.errors[:text]).to include("は100文字以内で入力してください") 
  end
end
