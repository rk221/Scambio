require 'rails_helper'

RSpec.describe ItemGenreGame, type: :system do
    let(:admin_user){FactoryBot.create(:admin_user)}
    let(:general_user){FactoryBot.create(:general_user)}

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

    describe 'アイテムジャンルゲームCRUD' do 
        describe '管理ユーザでログインしている場合' do
            let(:game_data){FactoryBot.build(:game)}
            let(:item_genre_data){FactoryBot.build(:item_genre)}
            let(:login_user){admin_user}
            include_context 'ユーザがログイン状態になる'


            shared_context 'アイテムジャンルゲームへ遷移し、作成されていることを確認' do
                before do
                    visit admin_games_path
                    click_link 'アイテムジャンル編集'
                end

                it '対応するアイテムジャンルゲームが表示されている' do
                    expect(page).to have_content 'アイテムジャンル名';
                    expect(page).to have_content '有効/無効';
                    expect(page).to have_content item_genre_data.name;
                    expect(page).to have_content '無効';
                end
            end

            describe 'アイテムジャンルゲーム新規登録' do
                shared_context 'アイテムジャンルゲームへ遷移し、作成されていることを確認' do
                    before do
                        visit admin_games_path
                        click_link 'アイテムジャンル編集'
                    end

                    it '対応するアイテムジャンルゲームが表示されている' do
                        expect(page).to have_content 'アイテムジャンル名';
                        expect(page).to have_content '有効/無効';
                        expect(page).to have_content item_genre_data.name;
                        expect(page).to have_content '無効';
                    end
                end

                context 'ゲームが登録済でアイテムジャンルを追加する場合' do
                    before do 
                        game_data.save
                        click_link 'アイテムジャンル'
                        click_link '登録'
                        fill_in 'アイテムジャンル名', with: item_genre_data.name
                        fill_in 'デフォルトの単位名', with: item_genre_data.default_unit_name
                        click_button '登録'
                    end

                    include_context 'アイテムジャンルゲームへ遷移し、作成されていることを確認'
                end

                context 'アイテムジャンルが登録済でゲームを追加する場合' do
                    before do 
                        item_genre_data.save
                        click_link 'ゲーム'
                        click_link '登録'
                        fill_in 'ゲームタイトル', with: game_data.title 
                        click_button '登録'
                    end

                    include_context 'アイテムジャンルゲームへ遷移し、作成されていることを確認'
                end
            end

            describe 'アイテムジャンルゲーム有効化/無効化' do
                let(:item_genre_game_data){FactoryBot.build(:item_genre_game)}
                before do
                    item_genre_data.save
                    game_data.save
                    item_genre_game_data.game_id = game_data.id
                    item_genre_game_data.item_genre_id = item_genre_data.id
                    item_genre_game_data.save
                end

                context 'アイテムジャンルゲーム編集画面へ遷移している' do 
                    before do
                        visit admin_games_path
                        click_link 'アイテムジャンル編集'
                    end

                    it '対応するアイテムジャンルゲームが表示されている' do
                        expect(page).to have_content 'アイテムジャンル名';
                        expect(page).to have_content '有効/無効';
                        expect(page).to have_content item_genre_data.name;
                        expect(page).to have_content '無効';
                    end

                    context '有効にする' do
                        before do 
                            click_link '無効'
                        end

                        it '有効になり、無効にするリンクが表示されている' do 
                            expect(page).to have_link '有効'
                            expect(page).to_not have_link '無効'
                        end
                        context '無効にする' do 
                            before do 
                                click_link '有効'
                            end

                            it '無効になり、有効にするリンクが表示されている' do 
                                expect(page).to have_link '無効'
                                expect(page).to_not have_link '有効'
                            end
                        end
                    end
                end
            end
        end
    end
end