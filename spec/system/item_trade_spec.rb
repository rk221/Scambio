require 'rails_helper'

RSpec.describe ItemTrade, type: :system do
    let!(:general_user){FactoryBot.create(:general_user)}
    let!(:admin_user){FactoryBot.create(:admin_user)}

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
                        @item_trade_queue = FactoryBot.create(:item_trade_queue, user_id: nil, enable_flag: true, item_trade_id: @item_trade.id)
                        @item_trade.update!(enable_item_trade_queue_id: @item_trade_queue.id)

                        visit current_path
                    end

                    it "登録したアイテムトレードが表示されている" do
                        expect(page).to have_content 'アイテムトレード一覧'
                        expect(page).to have_content @item_trade.buy_item.name
                        expect(page).to have_content @item_trade.sale_item.name
                    end
                end

                context '期限が無効なアイテムトレードを登録する' do
                    before do 
                        @item_trade = FactoryBot.create(:item_trade, user_id: login_user.id, game_id: game.id, buy_item_id: buy_item.id, sale_item_id: sale_item.id, enable_flag: true, trade_deadline: 1.hours.ago)
                        @item_trade_queue = FactoryBot.create(:item_trade_queue, user_id: nil, enable_flag: true, item_trade_id: @item_trade.id)
                        @item_trade.update!(enable_item_trade_queue_id: @item_trade_queue.id)
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
                        @item_trade_queue = FactoryBot.create(:item_trade_queue, user_id: nil, enable_flag: true, item_trade_id: @item_trade.id)
                        @item_trade.update!(enable_item_trade_queue_id: @item_trade_queue.id)
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

                    it '登録したアイテムトレードが表示されている' do
                        expect(page).to have_content 'あなたのアイテムトレード一覧'
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
                before do
                    @item_trade = FactoryBot.create(:item_trade, user_id: login_user.id, game_id: game.id, buy_item_id: buy_item.id, sale_item_id: sale_item.id, enable_flag: true, trade_deadline: 1.hours.since)
                    @item_trade_queue = FactoryBot.create(:item_trade_queue, user_id: nil, enable_flag: true, item_trade_id: @item_trade.id)
                    @item_trade.update!(enable_item_trade_queue_id: @item_trade_queue.id)
                    click_link 'ゲーム'
                    click_link 'アイテムトレード一覧'
                    click_link '詳細'
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

                    it 'あなたのアイテムトレード詳細画面で更新後のアイテムトレードが表示されている' do
                        expect(page).to have_content 'あなたのアイテムトレード詳細'
                        expect(page).to have_content @item_trade.buy_item.name
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
                        @item_trade_queue = FactoryBot.create(:item_trade_queue, user_id: nil, enable_flag: true, item_trade_id: @item_trade.id)
                        @item_trade.update!(enable_item_trade_queue_id: @item_trade_queue.id)
                        visit current_path
                    end

                    it "登録したアイテムトレードが表示されている" do
                        expect(page).to have_content 'アイテムトレード一覧'
                        expect(page).to have_content @item_trade.buy_item.name
                        expect(page).to have_content @item_trade.sale_item.name
                        expect(page).to have_content '詳細'
                    end

                    context '登録したアイテムトレードを削除する' do
                        before do
                            click_link '詳細'
                            click_link '削除'
                            accept_confirm
                        end

                        it '登録したアイテムトレードが無効化されている' do
                            expect(page).to have_content 'あなたのアイテムトレード一覧'
                            expect(page).to have_content @item_trade.buy_item.name
                            expect(page).to have_content @item_trade.sale_item.name
                            expect(page).to have_content '取引を有効化'
                        end
                    end
                end
            end
        end
    end


    describe 'アイテムトレード購入処理' do
        describe '購入ユーザでログインしている場合' do
            let!(:login_user){general_user}
            let!(:sale_user){admin_user}
            include_context 'ユーザがログイン状態になる'
            
            describe 'アイテムトレードが生成されている場合' do

                before do
                    @item_trade = FactoryBot.create(:item_trade, user_id: sale_user.id, game_id: game.id, buy_item_id: buy_item.id, sale_item_id: sale_item.id, enable_flag: true, trade_deadline: 1.hours.since)
                    @item_trade_queue = FactoryBot.create(:item_trade_queue, user_id: nil, enable_flag: true, establish_flag: nil, item_trade_id: @item_trade.id)
                    @item_trade.update!(enable_item_trade_queue_id: @item_trade_queue.id)

                    click_link 'ゲーム'
                    click_link 'アイテムトレード一覧'
                end

                it "登録したアイテムトレードが表示されている" do
                    expect(page).to have_content 'アイテムトレード一覧'
                    expect(page).to have_content @item_trade.buy_item.name
                    expect(page).to have_content @item_trade.sale_item.name
                end

                shared_context '購入ユーザ側で、取引が無効状態になっている' do
                    before do
                        click_link 'ログアウト'
                    end

                    include_context 'ユーザがログイン状態になる'

                    context '購入待ちアイテムトレード一覧に遷移する' do
                        before do
                            click_link '購入待ちアイテムトレード一覧'
                        end

                        it '取引が存在しない' do
                            expect(page).to have_content 'アイテムトレード購入待ち一覧'
                            expect(page).to_not have_content @item_trade.buy_item.name
                            expect(page).to_not have_content @item_trade.sale_item.name
                        end
                    end
                end

                shared_context '購入ユーザ側で、取引が有効状態になっている' do
                    before do
                        click_link 'ログアウト'
                    end

                    include_context 'ユーザがログイン状態になる'

                    context '購入待ちアイテムトレード一覧に遷移する' do
                        before do
                            click_link '購入待ちアイテムトレード一覧'
                        end

                        it '取引が有効状態で表示されている' do
                            expect(page).to have_content 'アイテムトレード購入待ち一覧'
                            expect(page).to have_content @item_trade.buy_item.name
                            expect(page).to have_content @item_trade.sale_item.name
                            expect(page).to have_content '詳細'
                        end
                    end
                end

                shared_context '売却ユーザ側で、取引が無効状態になっている' do
                    before do
                        click_link 'ログアウト'
                        fill_in 'メールアドレス', with: sale_user.email
                        fill_in 'パスワード', with: sale_user.password
                        click_button 'ログイン'
                    end

                    it '反応待ちにアイテムトレードが存在しない' do
                        expect(page).to have_content '反応待ちアイテムトレード一覧'
                        expect(page).to_not have_content @item_trade.buy_item.name
                        expect(page).to_not have_content @item_trade.sale_item.name
                        expect(page).to_not have_content '詳細'
                    end

                    context 'あなたのアイテムトレード一覧に遷移する' do
                        before do
                            click_link 'あなたのアイテムトレード一覧'
                        end

                        it '取引が無効状態で有効化リンクが表示されている' do
                            expect(page).to have_content 'あなたのアイテムトレード一覧'
                            expect(page).to have_content @item_trade.buy_item.name
                            expect(page).to have_content @item_trade.sale_item.name
                            expect(page).to have_content '取引を有効化'
                        end
                    end
                end

                shared_context '売却ユーザ側で、取引が相手の評価待ち状態になっている' do
                    before do
                        click_link 'ログアウト'
                        fill_in 'メールアドレス', with: sale_user.email
                        fill_in 'パスワード', with: sale_user.password
                        click_button 'ログイン'
                    end

                    it '反応待ちにアイテムトレードが存在しない' do
                        expect(page).to have_content '反応待ちアイテムトレード一覧'
                        expect(page).to_not have_content @item_trade.buy_item.name
                        expect(page).to_not have_content @item_trade.sale_item.name
                        expect(page).to_not have_content '詳細'
                    end

                    context 'あなたのアイテムトレード一覧に遷移する' do
                        before do
                            click_link 'あなたのアイテムトレード一覧'
                        end

                        it '取引が無効状態で有効化リンクが表示されている' do
                            expect(page).to have_content 'あなたのアイテムトレード一覧'
                            expect(page).to have_content @item_trade.buy_item.name
                            expect(page).to have_content @item_trade.sale_item.name
                            expect(page).to have_content '詳細'
                        end

                        context 'あなたのアイテムトレード詳細に遷移する' do
                            before do
                                click_link '詳細'    
                            end
                            
                            it '取引が相手の評価待ち状態になっている' do
                                expect(page).to have_content 'あなたのアイテムトレード詳細'
                                expect(page).to have_content @item_trade.buy_item.name
                                expect(page).to have_content @item_trade.sale_item.name
                                expect(page).to have_content '現在の取引状態'
                                expect(page).to have_content '相手の評価待ち'
                            end
                        end
                    end
                end

                shared_context '売却ユーザ側で、取引が有効状態になっている' do
                    before do
                        click_link 'ログアウト'
                        fill_in 'メールアドレス', with: sale_user.email
                        fill_in 'パスワード', with: sale_user.password
                        click_button 'ログイン'
                    end

                    it '反応待ちにアイテムトレードが表示されている' do
                        expect(page).to have_content '反応待ちアイテムトレード'
                        expect(page).to have_content @item_trade.buy_item.name
                        expect(page).to have_content @item_trade.sale_item.name
                    end
                end

                context '購入する' do
                    before do
                        click_link '購入'
                    end

                    it 'アイテムトレード購入待ち詳細で、購入しようとしているアイテムトレードが詳細表示されている' do
                        expect(page).to have_content 'アイテムトレード購入待ち詳細'
                        expect(page).to have_content @item_trade.buy_item.name
                        expect(page).to have_content @item_trade.sale_item.name
                        expect(page).to have_content '現在の取引状態'
                        expect(page).to have_content '相手の応答待ちです'
                    end
                    context 'ログアウトし、売却ユーザでログインしている' do
                        before do
                            click_link 'ログアウト'
                            fill_in 'メールアドレス', with: sale_user.email
                            fill_in 'パスワード', with: sale_user.password
                            click_button 'ログイン'
                        end

                        it '反応待ちにアイテムトレードが表示されている' do
                            expect(page).to have_content '反応待ちアイテムトレード'
                            expect(page).to have_content @item_trade.buy_item.name
                            expect(page).to have_content @item_trade.sale_item.name
                        end

                        context '反応待ち取引の詳細へ遷移する' do
                            before do
                                click_link '詳細'
                            end

                            it '登録したアイテムトレードが詳細表示されている' do
                                expect(page).to have_content 'あなたのアイテムトレード詳細'
                                expect(page).to have_content @item_trade.buy_item.name
                                expect(page).to have_content @item_trade.sale_item.name
                                expect(page).to have_content '取引を承諾'
                                expect(page).to have_content '取引を拒否'
                            end

                            context '取引を承認する' do
                                before do
                                    click_link '取引を承諾'
                                end

                                it '取引中になり、完了リンクが表示されている' do
                                    expect(page).to have_content 'あなたのアイテムトレード詳細'
                                    expect(page).to have_content @item_trade.buy_item.name
                                    expect(page).to have_content @item_trade.sale_item.name
                                    expect(page).to have_content '取引を完了'
                                end

                                context 'ログアウトし、購入ユーザでログインしている' do
                                    before do
                                        click_link 'ログアウト'
                                    end

                                    include_context 'ユーザがログイン状態になる'

                                    context '購入待ちアイテムトレード一覧に遷移する' do
                                        before do
                                            click_link '購入待ちアイテムトレード一覧'
                                        end

                                        it '購入待ちアイテムトレード一覧が表示されている' do
                                            expect(page).to have_content 'アイテムトレード購入待ち一覧'
                                            expect(page).to have_content @item_trade.buy_item.name
                                            expect(page).to have_content @item_trade.sale_item.name
                                            expect(page).to have_content '詳細'
                                        end

                                        context '購入待ちアイテムトレード詳細へ遷移する' do
                                            before do
                                                click_link '詳細'
                                            end

                                            it '購入待ちアイテムトレード詳細が表示されている' do
                                                expect(page).to have_content 'アイテムトレード購入待ち詳細'
                                                expect(page).to have_content @item_trade.buy_item.name
                                                expect(page).to have_content @item_trade.sale_item.name
                                            end

                                            it '取引中になっている' do
                                                expect(page).to have_content '取引中'
                                                expect(page).to have_content '取引を完了'
                                            end

                                            context '売却ユーザでマイページへ遷移する' do
                                                include_context '売却ユーザ側で、取引が有効状態になっている'

                                                context '有効な取引の詳細画面へ遷移する' do
                                                    before do
                                                        click_link '詳細'
                                                    end

                                                    it '有効な取引の詳細へ遷移している' do
                                                        expect(page).to have_content 'あなたのアイテムトレード詳細'                                                    
                                                        expect(page).to have_content @item_trade.buy_item.name
                                                        expect(page).to have_content @item_trade.sale_item.name
                                                        expect(page).to have_content '取引を完了'
                                                    end

                                                    context '売却ユーザで取引を完了する' do
                                                        before do
                                                            click_link '取引を完了'
                                                        end

                                                        it 'アイテムトレード評価へ遷移している' do
                                                            expect(page).to have_content 'アイテムトレード評価'
                                                            expect(page).to have_content '高評価'
                                                            expect(page).to have_content '普通'
                                                            expect(page).to have_content '低評価'
                                                        end

                                                        context '高評価を行う' do
                                                            before do
                                                                find('label[for=good]').click
                                                                click_button '送信'
                                                            end

                                                            it 'マイページへ遷移し、取引を終了したメッセージが表示されている' do
                                                                expect(page).to have_content '取引を終了しました'
                                                                expect(find('body')).to have_content 'マイページ'
                                                            end

                                                            it_behaves_like '購入ユーザ側で、取引が有効状態になっている'
                                                            it_behaves_like '売却ユーザ側で、取引が相手の評価待ち状態になっている'
                                                        end

                                                        context '普通評価を行う' do
                                                            before do
                                                                find('label[for=normal]').click
                                                                click_button '送信'
                                                            end

                                                            it 'マイページへ遷移し、取引を終了したメッセージが表示されている' do
                                                                expect(page).to have_content '取引を終了しました'
                                                                expect(find('body')).to have_content 'マイページ'
                                                            end

                                                            it_behaves_like '購入ユーザ側で、取引が有効状態になっている'
                                                            it_behaves_like '売却ユーザ側で、取引が相手の評価待ち状態になっている'
                                                        end

                                                        context '低評価を行う' do
                                                            before do
                                                                find('label[for=bad]').click
                                                                click_button '送信'
                                                            end

                                                            it 'マイページへ遷移し、取引を終了したメッセージが表示されている' do
                                                                expect(page).to have_content '取引を終了しました'
                                                                expect(find('body')).to have_content 'マイページ'
                                                            end

                                                            it_behaves_like '購入ユーザ側で、取引が有効状態になっている'
                                                            it_behaves_like '売却ユーザ側で、取引が相手の評価待ち状態になっている'
                                                        end
                                                    end
                                                end
                                            end

                                            context '購入ユーザで先に取引を完了する' do
                                                before do
                                                    click_link '取引を完了'
                                                end

                                                it 'アイテムトレード評価へ遷移している' do
                                                    expect(page).to have_content 'アイテムトレード評価'
                                                    expect(page).to have_content '高評価'
                                                    expect(page).to have_content '普通'
                                                    expect(page).to have_content '低評価'
                                                end

                                                context '高評価を行う' do
                                                    before do
                                                        find('label[for=good]').click
                                                        click_button '送信'
                                                    end

                                                    it 'マイページへ遷移し、取引を終了したメッセージが表示されている' do
                                                        expect(page).to have_content '取引を終了しました'
                                                        expect(find('body')).to have_content 'マイページ'
                                                    end

                                                    it_behaves_like '購入ユーザ側で、取引が無効状態になっている'
                                                    it_behaves_like '売却ユーザ側で、取引が有効状態になっている'
                                                end

                                                context '普通評価を行う' do
                                                    before do
                                                        find('label[for=normal]').click
                                                        click_button '送信'
                                                    end

                                                    it 'マイページへ遷移し、取引を終了したメッセージが表示されている' do
                                                        expect(page).to have_content '取引を終了しました'
                                                        expect(find('body')).to have_content 'マイページ'
                                                    end

                                                    it_behaves_like '購入ユーザ側で、取引が無効状態になっている'
                                                    it_behaves_like '売却ユーザ側で、取引が有効状態になっている'
                                                end

                                                context '低評価を行う' do
                                                    before do
                                                        find('label[for=bad]').click
                                                        click_button '送信'
                                                    end

                                                    it 'マイページへ遷移し、取引を終了したメッセージが表示されている' do
                                                        expect(page).to have_content '取引を終了しました'
                                                        expect(find('body')).to have_content 'マイページ'
                                                    end

                                                    it_behaves_like '購入ユーザ側で、取引が無効状態になっている'
                                                    it_behaves_like '売却ユーザ側で、取引が有効状態になっている'
                                                end
                                            end
                                        end
                                    end
                                end
                            end

                            context '取引を拒否する' do
                                before do
                                    click_link '取引を拒否'
                                end

                                it '取引編集画面が表示されている' do
                                    expect(page).to have_content 'アイテムトレード編集'
                                end

                                it_behaves_like '購入ユーザ側で、取引が無効状態になっている'
                                it_behaves_like '売却ユーザ側で、取引が無効状態になっている'
                            end
                        end
                    end
                end
            end
        end
    end
end