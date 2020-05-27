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

    describe 'マイページ' do
        describe 'ユーザでログインしている場合' do
            let(:login_user){general_user}
            include_context 'ユーザがログイン状態になる'
            context 'マイページに遷移している場合' do
                before do
                    click_link 'マイページ'
                end

                it 'ユーザ情報変更リンクが表示されている' do
                    expect(page).to have_link 'ユーザ情報変更'
                end

                it 'コード一覧リンクが表示されている' do
                    expect(page).to have_link 'コード一覧'
                end

                it 'あなたのアイテムトレード一覧リンクが表示されている' do
                    expect(page).to have_link 'あなたのアイテムトレード一覧'
                end

                context '最近取引されたゲームランク表示' do
                    let!(:user_game_rank){FactoryBot.create(:user_game_rank, user_id: login_user.id, game_id: game.id)}
                    before do
                        visit current_path
                    end

                    it 'ゲームランクが表示されている' do
                        expect(page).to have_content '最近取引されたゲーム'
                        expect(page).to have_content 'ゲームタイトル'
                        expect(page).to have_content game.title
                        expect(page).to have_content 'ランク'
                        expect(page).to have_content 'グレー'
                    end
                end
            end
        end
    end
end
