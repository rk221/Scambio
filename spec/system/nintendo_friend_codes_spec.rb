require 'rails_helper'

RSpec.describe NintendoFriendCode, type: :system do
    let(:general_user){FactoryBot.create(:user, admin_flag: false)}

    shared_context 'ユーザがログイン状態になる' do
        before do
            visit new_user_session_path
            fill_in 'メールアドレス', with: login_user.email
            fill_in 'パスワード', with: login_user.password
            click_button 'ログイン'
        end

        it '「ログインしました。」とフラッシュメッセージが表示されている' do
            expect(page).to have_content 'ログインしました。';
        end
    end

    let(:login_user){general_user}
    include_context 'ユーザがログイン状態になる'

    describe 'フレンドコードCRUD' do 
        before do
            click_link 'マイページ'
            click_link 'コード一覧'
        end


        describe 'フレンドコード登録' do 
            before do
                within(:css, '#nintendo-friend-code') do 
                    click_link('登録')
                end
            end

            it '登録画面へ遷移している' do
                expect(page).to have_content '任天堂フレンドコード登録'
            end

            context '登録画面へ遷移している' do
                let(:nintendo_friend_code){FactoryBot.build(:nintendo_friend_code)}
                before do 
                    fill_in 'フレンドコード', with: nintendo_friend_code.friend_code
                    click_button '登録'
                end

                it 'コード一覧画面へ遷移している' do 
                    expect(page).to have_content 'コード一覧'
                end

                it '任天堂フレンドコードが表示されている' do
                    split_codes = nintendo_friend_code.friend_code.scan(/.{1,#{4}}/)
                    expect(page).to have_content "#{split_codes[0]}-#{split_codes[1]}-#{split_codes[2]}"
                end
            end
        end

        describe 'フレンドコード編集' do 
            let!(:nintendo_friend_code){FactoryBot.create(:nintendo_friend_code, user_id: login_user.id)}
            before do
                visit current_path
                within(:css, '#nintendo-friend-code') do 
                    click_link('編集')
                end
            end

            it '編集画面へ遷移している' do
                expect(page).to have_content '任天堂フレンドコード編集'
            end

            context '編集画面へ遷移している' do
                let(:after_nintendo_friend_code){FactoryBot.build(:nintendo_friend_code, friend_code: '000000000000')}
                before do 
                    fill_in 'フレンドコード', with: after_nintendo_friend_code.friend_code
                    click_button '更新'
                end

                it 'コード一覧画面へ遷移している' do 
                    expect(page).to have_content 'コード一覧'
                end

                it '更新後の任天堂フレンドコードが表示されている' do
                    split_codes = after_nintendo_friend_code.friend_code.scan(/.{1,#{4}}/)
                    expect(page).to have_content "#{split_codes[0]}-#{split_codes[1]}-#{split_codes[2]}"
                end
            end
        end

        describe 'フレンドコード削除' do 
            let!(:nintendo_friend_code){FactoryBot.create(:nintendo_friend_code, user_id: login_user.id)}
            before do
                visit current_path
                within(:css, '#nintendo-friend-code') do 
                    click_link('削除')
                end
                accept_confirm
            end

            it 'コード一覧画面へ遷移している' do 
                expect(page).to have_content 'コード一覧'
            end

            it '任天堂フレンドコードが削除されている' do
                split_codes = nintendo_friend_code.friend_code.scan(/.{1,#{4}}/)
                expect(page).to_not have_content "#{split_codes[0]}-#{split_codes[1]}-#{split_codes[2]}"
            end
        end
    end
end