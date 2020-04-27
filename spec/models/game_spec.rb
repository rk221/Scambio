require 'rails_helper'

RSpec.describe Game, type: :model do
  it "タイトルがある場合、有効である" do
    game = FactoryBot.build(:game)
    expect(game).to be_valid
  end

  it "タイトルがない場合、無効である" do
    game = FactoryBot.build(:game, title: nil)
    game.valid?
    expect(game.errors[:title]).to include("を入力してください")
  end

  it "タイトルが重複している場合、無効である" do
    FactoryBot.create(:game)
    game = FactoryBot.build(:game)
    game.valid?
    expect(game.errors[:title]).to include("はすでに存在します")
    
  end
end
