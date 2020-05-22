require 'rails_helper'

RSpec.describe Game, type: :system do
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

    describe 'ゲームCRUD' do 
        describe '管理ユーザでログインしている場合' do
            let(:login_user){admin_user}
            include_context 'ユーザがログイン状態になる'

            context 'ゲーム一覧画面へ遷移している場合' do
                before do
                    click_link 'ゲーム管理'
                end

                it 'ゲーム一覧画面が表示されている' do
                    expect(page).to have_content 'ゲーム一覧'
                end
            end

            describe 'ゲーム新規登録' do
                before do
                    click_link 'ゲーム管理'
                    click_link '登録'
                end

                it 'ゲーム新規登録画面が表示されている' do 
                    expect(page).to have_content 'ゲーム登録'
                end

                context 'ゲームタイトルがある場合' do 
                    let(:game){FactoryBot.build(:game)} 
                    before do 
                        fill_in "ゲームタイトル", with: game.title 
                        click_button '登録'
                    end

                    it 'ゲーム一覧画面に登録されたゲームが表示されている' do
                        expect(page).to have_content 'ゲーム一覧'
                        expect(page).to have_content game.title
                    end
                end

                context 'ゲームタイトルが無い場合' do 
                    before do 
                        fill_in "ゲームタイトル", with: nil
                        click_button '登録'
                    end

                    it 'ゲーム新規登録画面でエラーメッセージが表示されている' do
                        expect(page).to have_content 'ゲーム登録'
                        expect(page).to have_content 'ゲームタイトルを入力してください'
                    end
                end

   
            end 

            describe 'ゲーム編集' do 
                let!(:game){FactoryBot.create(:game)} 
                before do
                    click_link 'ゲーム管理'
                    click_link '編集'
                end

                it 'ゲーム編集画面が表示されている' do 
                    expect(page).to have_content 'ゲーム編集'
                end

                context 'ゲームタイトルがある場合' do 
                    before do 
                        fill_in "ゲームタイトル", with: game.title + "更新版"
                        click_button '更新'
                    end

                    it 'ゲーム一覧画面に更新されたゲームが表示されている' do
                        expect(page).to have_content 'ゲーム一覧'
                        expect(page).to have_content game.title + "更新版"
                    end
                end

                context 'ゲームタイトルを消した場合' do 
                    before do 
                        fill_in "ゲームタイトル", with: "" 
                        click_button '更新'
                    end

                    it 'ゲーム編集画面でエラーメッセージが表示されている' do
                        expect(page).to have_content 'ゲーム編集'
                        expect(page).to have_content 'ゲームタイトルを入力してください'
                    end
                end   
            end

            describe 'ゲーム削除' do 
                let!(:game){FactoryBot.create(:game)} 
                before do
                    click_link 'ゲーム管理'
                    click_link '削除'
                    accept_confirm
                end

                it 'ゲームが削除されている' do 
                    expect(page).to have_content 'ゲーム一覧'
                    expect(page).to_not have_content game.title
                end
            end
        end
    
        describe '一般ユーザでログインしている場合' do
            let(:login_user){general_user}
            include_context 'ユーザがログイン状態になる'

            it 'ゲームへのリンクが存在しない' do 
                expect(page).to_not have_link 'ゲーム管理'
            end
        end
    end
end