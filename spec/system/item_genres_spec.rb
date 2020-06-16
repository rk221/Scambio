require 'rails_helper'
require 'support/user_shared_context'

RSpec.describe ItemGenre, type: :system do
    let(:admin_user){FactoryBot.create(:admin_user)}
    let(:general_user){FactoryBot.create(:general_user)}

    describe 'アイテムジャンルCRUD' do 
        describe '管理ユーザでログインしている場合' do
            let(:login_user){admin_user}
            include_context 'ユーザがログイン状態になる'

            context 'アイテムジャンル一覧画面へ遷移している場合' do
                before do
                    click_link 'アイテムジャンル'
                end

                it 'アイテムジャンル一覧画面が表示されている' do
                    expect(page).to have_content 'アイテムジャンル一覧'
                end
            end

            describe 'アイテムジャンル新規登録' do
                before do
                    click_link 'アイテムジャンル'
                    click_link '登録'
                end

                it 'アイテムジャンル新規登録画面が表示されている' do 
                    expect(page).to have_content 'アイテムジャンル登録'
                end

                context 'アイテムジャンルの名前、デフォルトの単位名がある場合' do 
                    let(:item_genre){FactoryBot.build(:item_genre)} 
                    before do 
                        fill_in "アイテムジャンル名", with: item_genre.name 
                        fill_in "デフォルトの単位名", with: item_genre.default_unit_name 
                        click_button '登録'
                    end

                    it 'アイテムジャンル一覧画面に登録されたアイテムジャンルが表示されている' do
                        expect(page).to have_content 'アイテムジャンル一覧'
                        expect(page).to have_content item_genre.name
                        expect(page).to have_content item_genre.default_unit_name
                    end
                end

                context 'アイテムジャンル名が無い場合' do 
                    before do 
                        fill_in "アイテムジャンル名", with: nil
                        click_button '登録'
                    end

                    it 'アイテムジャンル新規登録画面でエラーメッセージが表示されている' do
                        expect(page).to have_content 'アイテムジャンル登録'
                        expect(page).to have_content 'アイテムジャンル名を入力してください'
                    end
                end

                context 'デフォルトの単位名が無い場合' do 
                    before do 
                        fill_in "デフォルトの単位名", with: nil
                        click_button '登録'
                    end

                    it 'アイテムジャンル登録画面でエラーメッセージが表示されている' do
                        expect(page).to have_content 'アイテムジャンル登録'
                        expect(page).to have_content 'デフォルトの単位名を入力してください'
                    end
                end
   
            end 

            describe 'アイテムジャンル編集' do 
                let!(:item_genre){FactoryBot.create(:item_genre)} 
                before do
                    click_link 'アイテムジャンル'
                    click_link '編集'
                end

                it 'アイテムジャンル編集画面が表示されている' do 
                    expect(page).to have_content 'アイテムジャンル編集'
                end

                context 'アイテムジャンル名、デフォルトの単位名がある場合' do 
                    before do 
                        fill_in "アイテムジャンル名", with: item_genre.name + "更新版"
                        fill_in "デフォルトの単位名", with: item_genre.default_unit_name + "更新版"
                        click_button '更新'
                    end

                    it 'アイテムジャンル一覧画面に更新されたアイテムジャンルが表示されている' do
                        expect(page).to have_content 'アイテムジャンル一覧'
                        expect(page).to have_content item_genre.name + "更新版"
                        expect(page).to have_content item_genre.default_unit_name + "更新版"
                    end
                end

                context 'アイテムジャンル名を消した場合' do 
                    before do 
                        fill_in "アイテムジャンル名", with: "" 
                        click_button '更新'
                    end

                    it 'アイテムジャンル編集画面でエラーメッセージが表示されている' do
                        expect(page).to have_content 'アイテムジャンル編集'
                        expect(page).to have_content 'アイテムジャンル名を入力してください'
                    end
                end

                context 'デフォルトの単位名を消した場合' do 
                    before do 
                        fill_in "デフォルトの単位名", with: "" 
                        click_button '更新'
                    end

                    it 'アイテムジャンル編集画面でエラーメッセージが表示されている' do
                        expect(page).to have_content 'アイテムジャンル編集'
                        expect(page).to have_content 'デフォルトの単位名を入力してください'
                    end
                end
            end 

            describe 'アイテムジャンル編集' do 
                let!(:item_genre){FactoryBot.create(:item_genre)} 
                before do
                    click_link 'アイテムジャンル'
                    click_link '編集'
                end

                it 'アイテムジャンル編集画面が表示されている' do 
                    expect(page).to have_content 'アイテムジャンル編集'
                end

                context 'アイテムジャンル名、デフォルトの単位名がある場合' do 
                    before do 
                        fill_in "アイテムジャンル名", with: item_genre.name + "更新版"
                        fill_in "デフォルトの単位名", with: item_genre.default_unit_name + "更新版"
                        click_button '更新'
                    end

                    it 'アイテムジャンル一覧画面に更新されたアイテムジャンルが表示されている' do
                        expect(page).to have_content 'アイテムジャンル一覧'
                        expect(page).to have_content item_genre.name + "更新版"
                        expect(page).to have_content item_genre.default_unit_name + "更新版"
                    end
                end

                context 'アイテムジャンル名を消した場合' do 
                    before do 
                        fill_in "アイテムジャンル名", with: "" 
                        click_button '更新'
                    end

                    it 'アイテムジャンル編集画面でエラーメッセージが表示されている' do
                        expect(page).to have_content 'アイテムジャンル編集'
                        expect(page).to have_content 'アイテムジャンル名を入力してください'
                    end
                end   
            end

            describe 'アイテムジャンル削除' do 
                let!(:item_genre){FactoryBot.create(:item_genre)} 
                before do
                    click_link 'アイテムジャンル'
                    click_link '削除'
                    accept_confirm
                end

                it 'アイテムジャンルが削除されている' do 
                    expect(page).to have_content 'アイテムジャンル一覧'
                    expect(page).to_not have_content item_genre.name
                end
            end
        end
    
        describe '一般ユーザでログインしている場合' do
            let(:login_user){general_user}
            include_context 'ユーザがログイン状態になる'

            it 'アイテムジャンルへのリンクが存在しない' do 
                expect(page).to_not have_link 'アイテムジャンル'
            end
        end
    end
end