require 'rails_helper'

RSpec.describe User, type: :system do
    let(:general_user){FactoryBot.create(:general_user)}

    let!(:game){FactoryBot.create(:game)}
    let!(:item_genre){FactoryBot.create(:item_genre)}
    let!(:item_genre_game){FactoryBot.create(:item_genre_game, item_genre_id: item_genre.id, game_id: game.id, enable_flag: true)}
    let!(:buy_item){FactoryBot.create(:buy_item, item_genre_id: item_genre.id, game_id: game.id)}
    let!(:sale_item){FactoryBot.create(:sale_item, item_genre_id: item_genre.id, game_id: game.id)}

    shared_context 'ユーザがログイン状態になる' do
        before do
            visit new_user_session_path
            fill_in 'メールアドレス', with: login_user.email
            fill_in 'パスワード', with: login_user.password
            click_button 'ログイン'
        end

        it '「ログインしました。」とフラッシュメッセージが表示されている' do
            expect(page).to have_content 'ログインしました。'
        end
    end

    describe 'ユーザアイテムトレードRUD' do
        describe 'ユーザでログインしている場合' do
            let(:login_user){general_user}
            include_context 'ユーザがログイン状態になる'

            describe 'アイテムトレード一覧表示' do
                before do
                    click_link 'マイページ'
                    click_link 'あなたのアイテムトレード一覧'
                end

                it 'ユーザアイテムトレード一覧画面が表示されている' do
                    expect(page).to have_content 'あなたのアイテムトレード一覧'
                end

                context '有効なアイテムトレードを登録した状態で表示する' do
                    let!(:item_trade){FactoryBot.create(:item_trade, user_id: login_user.id, game_id: game.id, buy_item_id: buy_item.id, sale_item_id: sale_item.id, enable_flag: true, trade_deadline: 1.hours.since)}
                    before do
                        visit current_path
                    end

                    it 'ログインユーザの登録したアイテムトレードが表示されている' do
                        expect(page).to have_content game.title
                        expect(page).to have_content item_genre.name
                        expect(page).to have_content buy_item.name
                        expect(page).to have_content sale_item.name
                        expect(page).to have_link '編集'
                        expect(page).to have_link '削除'
                    end
                end

                context '無効なアイテムトレードを登録した状態で表示する' do
                    let!(:item_trade){FactoryBot.create(:item_trade, user_id: login_user.id, game_id: game.id, buy_item_id: buy_item.id, sale_item_id: sale_item.id, enable_flag: false)}
                    before do
                        visit current_path
                    end

                    it 'ログインユーザの登録したアイテムトレードが表示されている' do
                        expect(page).to have_content game.title
                        expect(page).to have_content item_genre.name
                        expect(page).to have_content buy_item.name
                        expect(page).to have_content sale_item.name
                        expect(page).to have_link '取引を有効化'
                    end
                end
            end
        end
    end
end
