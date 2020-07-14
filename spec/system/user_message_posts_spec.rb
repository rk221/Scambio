require 'rails_helper'
require 'support/user_shared_context'
require 'support/item_trade_shared_context'

RSpec.describe UserMessagePost, type: :system do
    let!(:sale_user){FactoryBot.create(:sale_user)}
    let!(:buy_user){FactoryBot.create(:buy_user)}

    let!(:game){FactoryBot.create(:game)}
    let!(:item_genre){FactoryBot.create(:item_genre)}
    let!(:item_genre_game){FactoryBot.create(:item_genre_game, item_genre_id: item_genre.id, game_id: game.id, enable: true)}
    let!(:buy_item){FactoryBot.create(:buy_item, item_genre_id: item_genre.id, game_id: game.id)}
    let!(:sale_item){FactoryBot.create(:sale_item, item_genre_id: item_genre.id, game_id: game.id)}

    let!(:buy_user_game_rank){FactoryBot.create(:user_game_rank, user_id: buy_user.id, game_id: game.id)}
    let!(:sale_user_game_rank){FactoryBot.create(:user_game_rank, user_id: sale_user.id, game_id: game.id)}

    describe 'アイテムトレード中のユーザメッセージ' do
        include_context '売却ユーザがログイン状態になる', :logout
            
        context 'アイテムトレードが登録されている場合' do
            let(:item_trade){FactoryBot.build(:item_trade, user_id: sale_user.id, game_id: game.id, buy_item_id: buy_item.id, sale_item_id: sale_item.id, enable: true, numeric_of_trade_deadline: 1, user_game_rank_id: sale_user_game_rank.id)}

            include_context 'アイテムトレードを登録する'

            context '購入ユーザでログインしている' do
                include_context '購入ユーザがログイン状態になる', :login

                context '購入する' do
                    before do
                        click_link 'ゲーム'
                        click_link 'アイテムトレード一覧'
                        click_link '購入'
                    end

                    context '売却ユーザでログインする' do
                        include_context '売却ユーザがログイン状態になる', :login

                        context '購入のメッセージが売却ユーザ側で存在する' do
                            before do
                                click_link '受信メッセージ一覧'
                            end

                            it '受信メッセージ一覧が表示されている' do
                                expect(page).to have_content '受信メッセージ一覧'
                            end

                            it '受信したメッセージが表示されている' do
                                expect(page).to have_content UserMessagePost.human_attribute_name(:subject)
                                expect(page).to have_content UserMessagePost.human_attribute_name(:created_at)
                                expect(page).to have_content '取引が購入されました'
                            end

                            context '詳細を表示する' do
                                before do
                                    find('tr[data-href]').click
                                end

                                it '受信したメッセージが表示されている' do
                                    expect(page).to have_content UserMessagePost.human_attribute_name(:subject)
                                    expect(page).to have_content UserMessagePost.human_attribute_name(:created_at)
                                    expect(page).to have_content '取引が購入されました'
                                    expect(page).to have_content UserMessagePost.human_attribute_name(:message)
                                    expect(page).to have_content '取引が購入されました。売却画面へ遷移してください。'
                                    expect(page).to have_content '詳細'
                                end
                            end
                        end

                        context '反応待ち取引の詳細へ遷移する' do
                            before do
                                click_link '詳細'
                            end

                            context '取引を承認する' do
                                before do
                                    click_link '取引を承諾'
                                end

                                context '購入ユーザでログインしている' do
                                    include_context '購入ユーザがログイン状態になる', :login

                                    context '購入待ちアイテムトレード詳細へ遷移する' do
                                        before do
                                            click_link '購入待ちアイテムトレード一覧'
                                            click_link '詳細'
                                        end

                                        context '売却ユーザでログインしている' do
                                            include_context '売却ユーザがログイン状態になる', :login 

                                            context '有効な取引の詳細画面へ遷移する' do
                                                before do
                                                    click_link 'マイページ'
                                                    click_link '詳細'
                                                end

                                                context '売却ユーザで取引を完了する' do
                                                    before do
                                                        click_link '取引を完了'
                                                    end

                                                    context '評価を行う' do
                                                        before do
                                                            find('label[for=good]').click
                                                            click_button '送信'
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end