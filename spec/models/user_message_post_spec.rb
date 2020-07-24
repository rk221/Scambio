require 'rails_helper'

RSpec.describe UserMessagePost, type: :model do
  let(:user){create(:user)}
  it "is valid with valid attributes" do
    user_message_post = build(:user_message_post, user: user)
    expect(user_message_post).to be_valid
  end

  it "is not valid without an user_id" do
    user_message_post = build(:user_message_post, user: nil)
    user_message_post.valid?
    expect(user_message_post.errors[:user_id]).to include("を入力してください") 
  end

  it "is not valid without a subject" do
    user_message_post = build(:user_message_post, subject: nil, user: user)
    user_message_post.valid?
    expect(user_message_post.errors[:subject]).to include("を入力してください") 
  end

  it "is not valid with a 101 characters or more subject" do
    user_message_post = build(:user_message_post, subject: 'a' * 101, user: user)
    user_message_post.valid?
    expect(user_message_post.errors[:subject]).to include("は100文字以内で入力してください") 
  end

  it "is not valid without a message" do
    user_message_post = build(:user_message_post, message: nil, user: user)
    user_message_post.valid?
    expect(user_message_post.errors[:message]).to include("を入力してください") 
  end

  it "is not valid without an already_read" do
    user_message_post = build(:user_message_post, already_read: nil, user: user)
    user_message_post.valid?
    expect(user_message_post.errors[:already_read]).to include("は一覧にありません") 
  end
end
