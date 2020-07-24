require 'rails_helper'

RSpec.describe Codes, type: :system do
    let(:general_user){create(:general_user)}

    describe 'Code Index' do 
        let(:login_user){general_user}
        include_context 'when user is logging in'

        context 'when transitioning to mypage' do
            before do
                click_link t_navbar(:mypage)
            end

            it 'a link to codes is displayed' do
                expect(page).to have_content t('users.show.codes')
            end

            context 'when transitioning to codes' do
                let!(:nintendo_friend_code){create(:nintendo_friend_code, user: login_user)}
                let!(:play_station_network_id){create(:play_station_network_id, user: login_user)}
                before do
                    click_link t('users.show.codes')
                end

                it 'a codes is displayed' do 
                    main_to_expect.to have_content t('codes.index.title')
                end

                it 'a nintendo friend code is displayed' do
                    split_codes = nintendo_friend_code.friend_code.scan(/.{1,#{4}}/)
                    main_to_expect.to have_content "#{split_codes[0]}-#{split_codes[1]}-#{split_codes[2]}"
                end

                it 'a play station network id is displayed' do
                    main_to_expect.to have_content play_station_network_id.psn_id
                end
            end
        end
    end
end