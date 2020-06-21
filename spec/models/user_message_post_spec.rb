require 'rails_helper'

RSpec.describe UserMessagePost, type: :model do
  let(:user){FactoryBot.create(:user)}
  it "ユーザID、件名、メッセージ、既読フラグがある場合、有効である" do 
    user_message_post = FactoryBot.build(:user_message_post, user_id: user.id)
    expect(user_message_post).to be_valid
  end

  it "ユーザIDが無い場合、無効である" do
    user_message_post = FactoryBot.build(:user_message_post, user_id: nil)
    user_message_post.valid?
    expect(user_message_post.errors[:user_id]).to include("を入力してください") 
  end

  it "件名が無い場合、無効である" do
    user_message_post = FactoryBot.build(:user_message_post, subject: nil, user_id: user.id)
    user_message_post.valid?
    expect(user_message_post.errors[:subject]).to include("を入力してください") 
  end

  it "件名が101文字以上場合、無効である" do
    user_message_post = FactoryBot.build(:user_message_post, subject: 'a' * 101, user_id: user.id)
    user_message_post.valid?
    expect(user_message_post.errors[:subject]).to include("は100文字以内で入力してください") 
  end

  it "メッセージが無い場合、無効である" do
    user_message_post = FactoryBot.build(:user_message_post, message: nil, user_id: user.id)
    user_message_post.valid?
    expect(user_message_post.errors[:message]).to include("を入力してください") 
  end

  it "既読フラグが無い場合、無効である" do
    user_message_post = FactoryBot.build(:user_message_post, already_read_flag: nil, user_id: user.id)
    user_message_post.valid?
    expect(user_message_post.errors[:already_read_flag]).to include("は一覧にありません") 
  end
end
