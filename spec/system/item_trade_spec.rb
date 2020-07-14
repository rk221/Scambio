require 'rails_helper'
require 'support/user_shared_context'
require 'support/item_trade_shared_context'

RSpec.describe ItemTrade, type: :system do
    let!(:general_user){FactoryBot.create(:general_user)}
    let!(:admin_user){FactoryBot.create(:admin_user)}
    let!(:sale_user){FactoryBot.create(:sale_user)}
    let!(:buy_user){FactoryBot.create(:buy_user)}

    let!(:game){FactoryBot.create(:game)}
    let!(:item_genre){FactoryBot.create(:item_genre)}
    let!(:item_genre_game){FactoryBot.create(:item_genre_game, item_genre_id: item_genre.id, game_id: game.id, enable: true)}
    let!(:buy_item){FactoryBot.create(:buy_item, item_genre_id: item_genre.id, game_id: game.id)}
    let!(:sale_item){FactoryBot.create(:sale_item, item_genre_id: item_genre.id, game_id: game.id)}

    let!(:user_game_rank){FactoryBot.create(:user_game_rank, user_id: admin_user.id, game_id: game.id)}
    let!(:buy_user_game_rank){FactoryBot.create(:user_game_rank, user_id: buy_user.id, game_id: game.id)}
    let!(:sale_user_game_rank){FactoryBot.create(:user_game_rank, user_id: sale_user.id, game_id: game.id)}
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
                    let(:item_trade){FactoryBot.build(:item_trade, user_id: login_user.id, game_id: game.id, buy_item_id: buy_item.id, sale_item_id: sale_item.id, enable: true, numeric_of_trade_deadline: 1, user_game_rank_id: user_game_rank.id)}
                    before do 
                        @item_trade = item_trade
                        @item_trade.save
                        @item_trade_queue = FactoryBot.create(:item_trade_queue, user_id: nil, item_trade_id: @item_trade.id)
                        @item_trade.update!(enable_item_trade_queue_id: @item_trade_queue.id)

                        visit current_path
                    end

                    it_behaves_like 'アイテムトレード一覧で取引が表示されていることを確認する'
                end

                context '有効フラグが無効なアイテムトレードを登録する' do
                    let(:item_trade){FactoryBot.build(:item_trade, user_id: login_user.id, game_id: game.id, buy_item_id: buy_item.id, sale_item_id: sale_item.id, enable: false, numeric_of_trade_deadline: 1, user_game_rank_id: user_game_rank.id)}
                    before do 
                        @item_trade = item_trade
                        @item_trade.save
                        @item_trade_queue = FactoryBot.create(:item_trade_queue, user_id: nil, item_trade_id: @item_trade.id)
                        @item_trade.update!(enable_item_trade_queue_id: @item_trade_queue.id)
                        visit current_path
                    end

                    it_behaves_like 'アイテムトレード一覧で取引が非表示になっていることを確認する'
                end
            end

            describe 'アイテムトレード登録' do
                let(:item_trade){FactoryBot.build(:item_trade, user_id: login_user.id, game_id: game.id, buy_item_id: buy_item.id, sale_item_id: sale_item.id, enable: true, numeric_of_trade_deadline: 1, user_game_rank_id: user_game_rank.id)}
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

                    it_behaves_like 'アイテムトレード一覧で取引が表示されていることを確認する'
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

                    it 'アイテム登録画面から遷移出来ずにいる' do
                        expect(page).to have_content 'アイテムトレード登録'
                    end
                end
            end

            describe 'アイテムトレード編集' do
                let(:item_trade){FactoryBot.build(:item_trade, user_id: login_user.id, game_id: game.id, buy_item_id: buy_item.id, sale_item_id: sale_item.id, enable: true, numeric_of_trade_deadline: 1, user_game_rank_id: user_game_rank.id)}
                include_context 'アイテムトレードを登録する'

                context 'アイテムトレードを編集する' do
                    before do
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
            end

            describe 'アイテムトレード削除' do
                let(:item_trade){FactoryBot.build(:item_trade, user_id: login_user.id, game_id: game.id, buy_item_id: buy_item.id, sale_item_id: sale_item.id, enable: true, numeric_of_trade_deadline: 1, user_game_rank_id: user_game_rank.id)}
                include_context 'アイテムトレードを登録する'

                context 'アイテムトレードを削除する' do
                    before do
                        click_link 'ゲーム'
                        click_link 'アイテムトレード一覧'
                        click_link '詳細'
                        click_link '削除'
                        accept_confirm
                    end

                    it_behaves_like 'アイテムトレード一覧で取引が非表示になっていることを確認する'

                    it 'あなたのアイテムトレード一覧が表示されている' do
                        expect(page).to have_content 'あなたのアイテムトレード一覧'
                    end

                    it '登録したアイテムトレードが無効化されている' do
                        expect(page).to have_content '取引を有効化'
                    end

                    include_context 'アイテムトレードの要素が表示されている'
                    include_context '取引期限が表示されていない'
                end
            end
        end
    end


    describe 'アイテムトレード購入処理' do
        include_context '売却ユーザがログイン状態になる', :logout
            
        context 'アイテムトレードが登録されている場合' do
            let(:item_trade){FactoryBot.build(:item_trade, user_id: sale_user.id, game_id: game.id, buy_item_id: buy_item.id, sale_item_id: sale_item.id, enable: true, numeric_of_trade_deadline: 1, user_game_rank_id: sale_user_game_rank.id)}

            include_context 'アイテムトレードを登録する'

            it_behaves_like 'アイテムトレード一覧で取引が表示されていることを確認する'

            context '購入ユーザでログインしている' do
                include_context '購入ユーザがログイン状態になる', :login

                context '購入する' do
                    before do
                        click_link 'ゲーム'
                        click_link 'アイテムトレード一覧'
                        click_link '購入'
                    end

                    it 'アイテムトレード購入待ち詳細へ遷移している' do
                        expect(page).to have_content 'アイテムトレード購入待ち詳細'
                    end

                    it '相手の応答待ち状態' do
                        expect(page).to have_content '現在の取引状態'
                        expect(page).to have_content '相手の応答待ちです'
                    end

                    it_behaves_like 'アイテムトレードの要素が表示されている'

                    context '売却ユーザでログインする' do
                        include_context '売却ユーザがログイン状態になる', :login

                        it_behaves_like '反応待ちアイテムトレードに取引が表示されている'

                        context '反応待ち取引の詳細へ遷移する' do
                            before do
                                click_link '詳細'
                            end

                            it 'あなたのアイテムトレード詳細へ遷移している' do
                                expect(page).to have_content 'あなたのアイテムトレード詳細'
                            end

                            it '応答待ち状態になっている' do
                                expect(page).to have_content '取引を承諾'
                                expect(page).to have_content '取引を拒否'
                            end

                            include_context 'アイテムトレードの要素が表示されている'
                            include_context '取引期限が表示されていない'

                            context '取引を承認する' do
                                before do
                                    click_link '取引を承諾'
                                end

                                it 'あなたのアイテムトレード詳細へ遷移している' do
                                    expect(page).to have_content 'あなたのアイテムトレード詳細'
                                end

                                it '取引中になり、完了リンクが表示されている' do
                                    expect(page).to have_content '取引を完了'
                                end

                                include_context 'アイテムトレードの要素が表示されている'
                                include_context '取引期限が表示されていない'

                                context '購入ユーザでログインしている' do
                                    include_context '購入ユーザがログイン状態になる', :login

                                    context '購入待ちアイテムトレード一覧に遷移する' do
                                        before do
                                            click_link '購入待ちアイテムトレード一覧'
                                        end

                                        it '購入待ちアイテムトレード一覧が表示されている' do
                                            expect(page).to have_content 'アイテムトレード購入待ち一覧'
                                        end

                                        it '取引が有効状態で表示されている' do
                                            expect(page).to have_content '詳細'
                                        end

                                        include_examples 'アイテムトレードの要素が表示されている'
                                        include_examples '取引期限が表示されていない'

                                        context '購入待ちアイテムトレード詳細へ遷移する' do
                                            before do
                                                click_link '詳細'
                                            end

                                            it '購入待ちアイテムトレード詳細へ遷移している' do
                                                expect(page).to have_content 'アイテムトレード購入待ち詳細'
                                            end

                                            it '取引中になっている' do
                                                expect(page).to have_content '取引が成立しています。チャットを行い、取引してください。'
                                                expect(page).to have_content '取引を完了'
                                            end

                                            include_examples 'アイテムトレードの要素が表示されている'
                                            include_examples '取引期限が表示されていない'

                                            context '売却ユーザでログインしている' do
                                                include_context '売却ユーザがログイン状態になる', :login 

                                                context '有効な取引の詳細画面へ遷移する' do
                                                    before do
                                                        click_link 'マイページ'
                                                        click_link '詳細'
                                                    end

                                                    it '有効な取引の詳細へ遷移している' do
                                                        expect(page).to have_content 'あなたのアイテムトレード詳細'                                                    
                                                    end

                                                    it '取引中になっている' do
                                                        expect(page).to have_content '取引中'
                                                        expect(page).to have_content '取引を完了'
                                                    end

                                                    include_examples 'アイテムトレードの要素が表示されている'
                                                    include_examples '取引期限が表示されていない'

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

                                                            it_behaves_like '購入ユーザ側で、取引が有効状態になっている', :login
                                                            it_behaves_like '売却ユーザ側で、取引が相手の評価待ち状態になっている', :login
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

                                                            it_behaves_like '購入ユーザ側で、取引が有効状態になっている', :login
                                                            it_behaves_like '売却ユーザ側で、取引が相手の評価待ち状態になっている', :login
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

                                                            it_behaves_like '購入ユーザ側で、取引が有効状態になっている', :login
                                                            it_behaves_like '売却ユーザ側で、取引が相手の評価待ち状態になっている', :login
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

                                                    it_behaves_like '購入ユーザ側で、取引が無効状態になっている', :login
                                                    it_behaves_like '売却ユーザ側で、取引が有効状態になっている', :login
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

                                                    it_behaves_like '購入ユーザ側で、取引が無効状態になっている', :login
                                                    it_behaves_like '売却ユーザ側で、取引が有効状態になっている', :login
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

                                                    it_behaves_like '購入ユーザ側で、取引が無効状態になっている', :login
                                                    it_behaves_like '売却ユーザ側で、取引が有効状態になっている', :login
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

                                it_behaves_like '購入ユーザ側で、取引が無効状態になっている', :login
                                it_behaves_like '売却ユーザ側で、取引が無効状態になっている', :login
                            end
                        end
                    end
                end
            end
        end
    end
end