require 'rails_helper'

RSpec.describe PlayStationNetworkId, type: :model do
  let(:user){FactoryBot.create(:user)}
  it "ユーザID、PSN_IDがある場合、有効である" do 
    play_station_network_id = FactoryBot.build(:play_station_network_id, user_id: user.id)
    expect(play_station_network_id).to be_valid
  end

  it "ユーザIDが無い場合、無効である" do
    play_station_network_id = FactoryBot.build(:play_station_network_id, user_id: nil)
    play_station_network_id.valid?
    expect(play_station_network_id.errors[:user_id]).to include("を入力してください") 
  end

  it "ユーザIDが重複している場合、無効である" do
    FactoryBot.create(:play_station_network_id, user_id: user.id)
    play_station_network_id = FactoryBot.build(:play_station_network_id, user_id: user.id)
    play_station_network_id.valid?
    expect(play_station_network_id.errors[:user_id]).to include("はすでに存在します") 
  end

  it "PSN_IDが無い場合、無効である" do
    play_station_network_id = FactoryBot.build(:play_station_network_id, psn_id: nil, user_id: user.id)
    play_station_network_id.valid?
    expect(play_station_network_id.errors[:psn_id]).to include("を入力してください") 
  end

  it "PSN_IDが先頭が英字ではない場合、無効である" do
    play_station_network_id = FactoryBot.build(:play_station_network_id, psn_id: '1psn', user_id: user.id)
    play_station_network_id.valid?
    expect(play_station_network_id.errors[:psn_id]).to include("は先頭英字で入力してください") 
  end

  it "PSN_IDが使用出来ない値の場合、無効である" do
    play_station_network_id = FactoryBot.build(:play_station_network_id, psn_id: 'psn><泣', user_id: user.id)
    play_station_network_id.valid?
    expect(play_station_network_id.errors[:psn_id]).to include("は不正な値です") 
  end

  it "PSN_IDが3文字未満の場合、無効である" do
    play_station_network_id = FactoryBot.build(:play_station_network_id, psn_id: '1' * 2, user_id: user.id)
    play_station_network_id.valid?
    expect(play_station_network_id.errors[:psn_id]).to include("は3文字以上で入力してください") 
  end

  it "PSN_IDが17文字以上の場合、無効である" do
    play_station_network_id = FactoryBot.build(:play_station_network_id, psn_id: '1' * 17, user_id: user.id)
    play_station_network_id.valid?
    expect(play_station_network_id.errors[:psn_id]).to include("は16文字以内で入力してください") 
  end
end
