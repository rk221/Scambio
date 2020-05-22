require 'rails_helper'

RSpec.describe ItemTrade, type: :system do
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
            expect(page).to have_content 'ログインしました。';
        end
    end

    describe 'アイテムトレードCRUD' do 
        describe 'ユーザでログインしている場合' do
            let(:login_user){general_user}
            include_context 'ユーザがログイン状態になる'


            describe 'アイテムトレード一覧表示' do
                before do
                    click_link 'ゲーム'
                    click_link 'アイテムトレード一覧'
                end

                it 'アイテムトレード一覧画面が表示されている' do
                    expect(page).to have_content 'アイテムトレード一覧'
                end

                context '期限、有効フラグ共に有効なアイテムトレードを登録する' do
                    before do 
                        @item_trade = FactoryBot.create(:item_trade, user_id: login_user.id, game_id: game.id, buy_item_id: buy_item.id, sale_item_id: sale_item.id, enable_flag: true, trade_deadline: 1.hours.since)
                        visit current_path
                    end

                    it "登録したアイテムトレードが表示されている" do
                        expect(page).to have_content login_user.nickname
                        expect(page).to have_content @item_trade.buy_item.name
                        expect(page).to have_content @item_trade.sale_item.name
                    end
                end

                context '期限が無効なアイテムトレードを登録する' do
                    before do 
                        @item_trade = FactoryBot.create(:item_trade, user_id: login_user.id, game_id: game.id, buy_item_id: buy_item.id, sale_item_id: sale_item.id, enable_flag: true, trade_deadline: 1.hours.ago)
                        visit current_path
                    end

                    it "アイテムトレードが表示されていない" do
                        expect(page).to_not have_content login_user.nickname
                        expect(page).to_not have_content @item_trade.buy_item.name
                        expect(page).to_not have_content @item_trade.sale_item.name
                    end
                end

                context '有効フラグが無効なアイテムトレードを登録する' do
                    before do 
                        @item_trade = FactoryBot.create(:item_trade, user_id: login_user.id, game_id: game.id, buy_item_id: buy_item.id, sale_item_id: sale_item.id, enable_flag: false, trade_deadline: 1.hours.since)
                        visit current_path
                    end

                    it "アイテムトレードが表示されていない" do
                        expect(page).to_not have_content login_user.nickname
                        expect(page).to_not have_content @item_trade.buy_item.name
                        expect(page).to_not have_content @item_trade.sale_item.name
                    end
                end
            end

            describe 'アイテムトレード登録' do
                let(:item_trade){FactoryBot.build(:item_trade, user_id: login_user.id, game_id: game.id, buy_item_id: buy_item.id, sale_item_id: sale_item.id, enable_flag: true, trade_deadline: 1.hours.since)}
                before do
                    click_link 'ゲーム'
                    click_link 'アイテムトレード一覧'
                    click_link '取引登録'
                end
                    
                it 'アイテムトレード登録画面が表示されている' do 
                    expect(page).to have_content 'アイテムトレード登録'
                end

                context '有効なデータで登録する' do
                    before do
                        select item_trade.buy_item.item_genre.name, from: '購入アイテムジャンル'
                        fill_in '購入アイテム名', with: item_trade.buy_item.name
                        fill_in '購入数量', with: item_trade.buy_item_quantity

                        select item_trade.sale_item.item_genre.name, from: '売却アイテムジャンル'
                        fill_in '売却アイテム名', with: item_trade.sale_item.name
                        fill_in '売却数量', with: item_trade.sale_item_quantity
                        fill_in '取引期限', with: 1
                        click_button '登録'
                    end

                    it 'アイテムトレードが表示されている' do
                        expect(page).to have_content 'アイテムトレード一覧'
                        expect(page).to have_content login_user.nickname
                        expect(page).to have_content item_trade.buy_item.name
                        expect(page).to have_content item_trade.sale_item.name
                    end
                end

                context 'アイテム名を入力せずに登録する' do
                    before do
                        select item_trade.buy_item.item_genre.name, from: '購入アイテムジャンル'
                        fill_in '購入数量', with: item_trade.buy_item_quantity

                        select item_trade.sale_item.item_genre.name, from: '売却アイテムジャンル'
                        fill_in '売却数量', with: item_trade.sale_item_quantity
                        fill_in '取引期限', with: 1
                        click_button '登録'
                    end

                    it 'アイテム登録画面でエラーメッセージが表示されている' do
                        expect(page).to have_content 'アイテムトレード登録'
                        expect(page).to have_content "購入アイテム名を入力してください"
                        expect(page).to have_content "売却アイテム名を入力してください"
                    end
                end
            end

            describe 'アイテムトレード編集' do
                let!(:item_trade){FactoryBot.create(:item_trade, user_id: login_user.id, game_id: game.id, buy_item_id: buy_item.id, sale_item_id: sale_item.id, enable_flag: true, trade_deadline: 1.hours.since)}
                before do
                    click_link 'ゲーム'
                    click_link 'アイテムトレード一覧'
                    click_link '編集'
                end

                it 'アイテムトレード編集画面が表示されている' do
                    expect(page).to have_content 'アイテムトレード編集'
                end

                context '数量と期限を変更し更新する' do
                    before do
                        fill_in '購入数量', with: 100
                        fill_in '売却数量', with: 20
                        fill_in '取引期限（今から何時間有効か）', with: 3
                        click_button '更新'
                    end

                    it 'アイテムトレード一覧画面で更新後のアイテムトレードが表示されている' do
                        expect(page).to have_content 'アイテムトレード一覧'
                        expect(page).to have_content login_user.nickname
                        expect(page).to have_content item_trade.buy_item.name
                        expect(page).to have_content '100'
                        expect(page).to have_content '20'
                    end
                end

                context '空の値で更新する' do
                    before do
                        fill_in '購入数量', with: ""
                        fill_in '売却数量', with: ""
                        fill_in '取引期限（今から何時間有効か）', with: ""
                        click_button '更新'
                    end

                    it 'アイテムトレード編集画面でエラーメッセージが表示されている' do
                        expect(page).to have_content 'アイテムトレード編集'
                        expect(page).to have_content '購入数量を入力してください'
                        expect(page).to have_content '売却数量を入力してください'
                        expect(page).to have_content '取引期限を入力してください'
                        expect(page).to have_content '購入数量は数値で入力してください'
                        expect(page).to have_content '売却数量は数値で入力してください'
                    end
                end
            end

            describe 'アイテムトレード削除' do
                before do
                    click_link 'ゲーム'
                    click_link 'アイテムトレード一覧'
                end

                it 'アイテムトレード一覧画面が表示されている' do
                    expect(page).to have_content 'アイテムトレード一覧'
                end

                context '期限、有効フラグ共に有効なアイテムトレードを登録する' do
                    before do 
                        @item_trade = FactoryBot.create(:item_trade, user_id: login_user.id, game_id: game.id, buy_item_id: buy_item.id, sale_item_id: sale_item.id, enable_flag: true, trade_deadline: 1.hours.since)
                        visit current_path
                    end

                    it "登録したアイテムトレードが表示されている" do
                        expect(page).to have_content login_user.nickname
                        expect(page).to have_content @item_trade.buy_item.name
                        expect(page).to have_content @item_trade.sale_item.name
                    end

                    context '登録したアイテムトレードを削除する' do
                        before do
                            click_link '削除'
                            accept_confirm
                        end

                        it '登録したアイテムトレードが削除されている' do
                            expect(page).to_not have_content login_user.nickname
                            expect(page).to_not have_content @item_trade.buy_item.name
                            expect(page).to_not have_content @item_trade.sale_item.name
                        end
                    end
                end
            end
        end
    end
end