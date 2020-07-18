require 'rails_helper'

RSpec.describe PlayStationNetworkId, type: :model do
  let(:user){create(:user)}
  it "is valid with valid attributes" do
    play_station_network_id = build(:play_station_network_id, user: user)
    expect(play_station_network_id).to be_valid
  end

  it "is not valid without an user_id" do
    play_station_network_id = build(:play_station_network_id, user: nil)
    play_station_network_id.valid?
    expect(play_station_network_id.errors[:user_id]).to include("を入力してください") 
  end

  it "is not valid with a not unique user_id" do
    create(:play_station_network_id, user: user)
    play_station_network_id = build(:play_station_network_id, user: user)
    play_station_network_id.valid?
    expect(play_station_network_id.errors[:user_id]).to include("はすでに存在します") 
  end

  it "is not valid without a psn_id" do
    play_station_network_id = build(:play_station_network_id, psn_id: nil, user: user)
    play_station_network_id.valid?
    expect(play_station_network_id.errors[:psn_id]).to include("を入力してください") 
  end

  it "is not valid with a not head alphabet psn_id" do
    play_station_network_id = build(:play_station_network_id, psn_id: '1psn', user: user)
    play_station_network_id.valid?
    expect(play_station_network_id.errors[:psn_id]).to include("は先頭英字で入力してください") 
  end

  it "is not valid with an invalid format psn_id" do
    play_station_network_id = build(:play_station_network_id, psn_id: 'psn><泣', user: user)
    play_station_network_id.valid?
    expect(play_station_network_id.errors[:psn_id]).to include("は不正な値です") 
  end

  it "is not valid with a 2 characters or less psn_id" do
    play_station_network_id = build(:play_station_network_id, psn_id: '1' * 2, user: user)
    play_station_network_id.valid?
    expect(play_station_network_id.errors[:psn_id]).to include("は3文字以上で入力してください") 
  end

  it "is not valid with a 17 characters or more psn_id" do
    play_station_network_id = build(:play_station_network_id, psn_id: '1' * 17, user: user)
    play_station_network_id.valid?
    expect(play_station_network_id.errors[:psn_id]).to include("は16文字以内で入力してください") 
  end
end
