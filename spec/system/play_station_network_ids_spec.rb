require 'rails_helper'

RSpec.describe PlayStationNetworkId, type: :system do
    let(:general_user){create(:general_user)}

    let(:login_user){general_user}
    include_context 'when user is logging in'

    describe 'PSN_ID' do 
        before do
            click_link t('users.show.codes')
        end


        describe 'Create' do 
            before do
                within(:css, '#play-station-network-id') do 
                    click_link t_link_to(:regist)
                end
            end

            it 'a create of play station newtwork id is displayed' do
                main_to_expect.to have_content t('codes.play_station_network_ids.new.title')
            end

            context 'when transitioning to create of play station newtwork id' do
                let(:play_station_network_id){build(:play_station_network_id)}
                before do 
                    fill_in t_model_attribute_name(PlayStationNetworkId, :psn_id), with: play_station_network_id.psn_id
                    click_button t_submit(:create)
                end

                it 'a codes is displayed' do 
                    main_to_expect.to have_content t('codes.index.title')
                end

                it 'a play station network id is displayed' do
                    main_to_expect.to have_content play_station_network_id.psn_id
                end
            end
        end

        describe 'Edit' do 
            let!(:play_station_network_id){create(:play_station_network_id, user: login_user)}
            before do
                visit current_path
                within(:css, '#play-station-network-id') do 
                    click_link t_link_to(:edit)
                end
            end

            it 'a edit of play station newtwork id is displayed' do
                main_to_expect.to have_content t('codes.play_station_network_ids.edit.title')
            end

            context 'when transitioning to edit of play station newtwork id' do
                let(:after_play_station_network_id){build(:play_station_network_id, psn_id: 'afterid')}
                before do 
                    fill_in t_model_attribute_name(PlayStationNetworkId, :psn_id), with: after_play_station_network_id.psn_id
                    click_button t_submit(:update)
                end

                it 'a codes is displayed' do 
                    main_to_expect.to have_content t('codes.index.title')
                end

                it 'a after play station network id is displayed' do
                    main_to_expect.to have_content after_play_station_network_id.psn_id
                end
            end
        end

        describe 'Destroy' do 
            let!(:play_station_network_id){create(:play_station_network_id, user: login_user)}
            before do
                visit current_path
                within(:css, '#play-station-network-id') do 
                    click_link t_link_to(:destroy)
                end
                accept_confirm
            end

            it 'a codes is displayed' do
                main_to_expect.to have_content t('codes.index.title')
            end

            it 'a play station network id is not displayed' do
                main_to_expect.to_not have_content play_station_network_id.psn_id
            end
        end
    end
end