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
end
