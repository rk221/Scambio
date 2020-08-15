require 'rails_helper'

RSpec.describe NintendoFriendCode, type: :system do
    let(:general_user){create(:general_user)}

    let(:login_user){general_user}
    include_context 'when user is logging in'

    describe 'Nintendo Friend Code' do 
        before do
            click_link t('users.show.codes')
        end


        describe 'Create' do 
            before do
                within(:css, '#nintendo-friend-code') do 
                    click_link t_link_to(:regist)
                end
            end

            it 'a create of nintendo friend code is displayed' do
                main_to_expect.to have_content t('users.codes.nintendo_friend_codes.new.title')
            end

            context 'when transitioning to create of nintendo friend code' do
                let(:nintendo_friend_code){build(:nintendo_friend_code)}
                before do 
                    fill_in t_model_attribute_name(NintendoFriendCode, :friend_code), with: nintendo_friend_code.friend_code
                    click_button t_submit(:create)
                end

                it 'a codes is displayed' do 
                    main_to_expect.to have_content t('users.codes.index.title')
                end

                it 'a nintendo friend code is displayed' do
                    split_codes = nintendo_friend_code.friend_code.scan(/.{1,#{4}}/)
                    main_to_expect.to have_content "#{split_codes[0]}-#{split_codes[1]}-#{split_codes[2]}"
                end
            end
        end

        describe 'Edit' do 
            let!(:nintendo_friend_code){create(:nintendo_friend_code, user: login_user)}
            before do
                visit current_path
                within(:css, '#nintendo-friend-code') do 
                    click_link t_link_to(:edit)
                end
            end

            it 'a edit of nintendo_friend_codes is displayed' do
                main_to_expect.to have_content t('users.codes.nintendo_friend_codes.edit.title')
            end

            context 'when transitioning to edit of nintendo friend code' do
                let(:after_nintendo_friend_code){build(:nintendo_friend_code, friend_code: '000000000000')}
                before do 
                    fill_in t_model_attribute_name(NintendoFriendCode, :friend_code), with: after_nintendo_friend_code.friend_code
                    click_button t_submit(:update)
                end

                it 'a codes is displayed' do 
                    main_to_expect.to have_content t('users.codes.index.title')
                end

                it 'a after nintendo friend code is displayed' do
                    split_codes = after_nintendo_friend_code.friend_code.scan(/.{1,#{4}}/)
                    main_to_expect.to have_content "#{split_codes[0]}-#{split_codes[1]}-#{split_codes[2]}"
                end
            end
        end

        describe 'Destroy' do 
            let!(:nintendo_friend_code){create(:nintendo_friend_code, user: login_user)}
            before do
                visit current_path
                within(:css, '#nintendo-friend-code') do 
                    click_link t_link_to(:destroy)
                end
                accept_confirm
            end

            it 'a codes is displayed' do 
                main_to_expect.to have_content t('users.codes.index.title')
            end

            it 'a nintendo friend code is not displayed' do
                split_codes = nintendo_friend_code.friend_code.scan(/.{1,#{4}}/)
                main_to_expect.to_not have_content "#{split_codes[0]}-#{split_codes[1]}-#{split_codes[2]}"
            end
        end
    end
end