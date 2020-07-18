require 'rails_helper'

RSpec.describe Game, type: :model do
  it "is valid with valid attributes" do
    game = build(:game)
    expect(game).to be_valid
  end

  it "is not valid without a title" do
    game = build(:game, title: nil)
    game.valid?
    expect(game.errors[:title]).to include("を入力してください")
  end

  it "is not valid with a not unique title" do
    create(:game)
    game = build(:game)
    game.valid?
    expect(game.errors[:title]).to include("はすでに存在します")
    
  end
end
