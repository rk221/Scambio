require 'rails_helper'
require 'support/user_shared_context'

RSpec.describe PlayStationNetworkId, type: :system do
    let(:general_user){FactoryBot.create(:general_user)}

    let(:login_user){general_user}
    include_context 'ユーザがログイン状態になる'

    describe 'PSN_IDCRUD' do 
        before do
            click_link 'マイページ'
            click_link 'コード一覧'
        end


        describe 'PSN_ID登録' do 
            before do
                within(:css, '#play-station-network-id') do 
                    click_link('登録')
                end
            end

            it '登録画面へ遷移している' do
                expect(page).to have_content 'PlayStationNetworkID登録'
            end

            context '登録画面へ遷移している' do
                let(:play_station_network_id){FactoryBot.build(:play_station_network_id)}
                before do 
                    fill_in 'PSN_ID', with: play_station_network_id.psn_id
                    click_button '登録'
                end

                it 'コード一覧画面へ遷移している' do 
                    expect(page).to have_content 'コード一覧'
                end

                it 'PlayStationNetworkIDが表示されている' do
                    expect(page).to have_content play_station_network_id.psn_id
                end
            end
        end

        describe 'PSN_ID編集' do 
            let!(:play_station_network_id){FactoryBot.create(:play_station_network_id, user_id: login_user.id)}
            before do
                visit current_path
                within(:css, '#play-station-network-id') do 
                    click_link('編集')
                end
            end

            it '編集画面へ遷移している' do
                expect(page).to have_content 'PlayStationNetworkID編集'
            end

            context '編集画面へ遷移している' do
                let(:after_play_station_network_id){FactoryBot.build(:play_station_network_id, psn_id: 'afterid')}
                before do 
                    fill_in 'PSN_ID', with: after_play_station_network_id.psn_id
                    click_button '更新'
                end

                it 'コード一覧画面へ遷移している' do 
                    expect(page).to have_content 'コード一覧'
                end

                it '更新後のPlayStationNetworkIDが表示されている' do
                    expect(page).to have_content after_play_station_network_id.psn_id
                end
            end
        end

        describe 'PSN_ID削除' do 
            let!(:play_station_network_id){FactoryBot.create(:play_station_network_id, user_id: login_user.id)}
            before do
                visit current_path
                within(:css, '#play-station-network-id') do 
                    click_link('削除')
                end
                accept_confirm
            end

            it 'コード一覧画面へ遷移している' do 
                expect(page).to have_content 'コード一覧'
            end

            it 'PlayStationNetworkIDが削除されている' do
                expect(page).to_not have_content play_station_network_id.psn_id
            end
        end
    end
end