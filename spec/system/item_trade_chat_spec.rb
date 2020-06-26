require 'rails_helper'
require 'support/user_shared_context'
require 'support/item_trade_shared_context'

RSpec.describe ItemTradeChat, type: :system do
    let!(:general_user){FactoryBot.create(:general_user)}
    let!(:admin_user){FactoryBot.create(:admin_user)}
    let!(:sale_user){FactoryBot.create(:sale_user)}
    let!(:buy_user){FactoryBot.create(:buy_user)}

    let!(:game){FactoryBot.create(:game)}
    let!(:item_genre){FactoryBot.create(:item_genre)}
    let!(:item_genre_game){FactoryBot.create(:item_genre_game, item_genre_id: item_genre.id, game_id: game.id, enable_flag: true)}
    let!(:buy_item){FactoryBot.create(:buy_item, item_genre_id: item_genre.id, game_id: game.id)}
    let!(:sale_item){FactoryBot.create(:sale_item, item_genre_id: item_genre.id, game_id: game.id)}

    let!(:buy_user_game_rank){FactoryBot.create(:user_game_rank, user_id: buy_user.id, game_id: game.id)}
    let!(:sale_user_game_rank){FactoryBot.create(:user_game_rank, user_id: sale_user.id, game_id: game.id)}

    let!(:sale_fixed_phrase){FactoryBot.create(:fixed_phrase, user_id: sale_user.id)}
    let!(:buy_fixed_phrase){FactoryBot.create(:fixed_phrase, user_id: buy_user.id)}

    describe 'アイテムトレード購入処理' do
        include_context '売却ユーザがログイン状態になる', :logout
            
        context 'アイテムトレードが登録されている場合' do
            let(:item_trade){FactoryBot.build(:item_trade, user_id: sale_user.id, game_id: game.id, buy_item_id: buy_item.id, sale_item_id: sale_item.id, enable_flag: true, trade_deadline: 1.hours.since, user_game_rank_id: sale_user_game_rank.id)}

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

                    context '売却ユーザでログインする' do
                        include_context '売却ユーザがログイン状態になる', :login

                        context '取引を承認する' do
                            before do
                                click_link '詳細'
                                click_link '取引を承諾'
                            end

                            it 'チャットが表示されている' do
                                expect(page).to have_content 'チャット'
                            end

                            context '売却ユーザで定形文を送信する' do
                                before do
                                    find("#fixed_phrases_dropdown").click
                                    sleep 2
                                    find(".dropdown-item").click
                                    sleep 2
                                end

                                it '定形文が反映されている' do
                                    sleep 2
                                    expect(page).to have_content sale_fixed_phrase.text
                                end
                            end

                            context '売却ユーザでチャットを送信する' do
                                before do
                                    fill_in 'item_trade_chat_message',	with: "テストメッセージ" 
                                    sleep 1
                                    click_button '送信'
                                end

                                it 'チャットが反映されている' do
                                    sleep 2
                                    expect(page).to have_content 'テストメッセージ'
                                end

                                context '購入ユーザでログインしている' do
                                    include_context '購入ユーザがログイン状態になる', :login

                                    context '購入待ちアイテムトレード詳細に遷移する' do
                                        before do
                                            click_link '購入待ちアイテムトレード一覧'
                                            click_link '詳細'
                                        end

                                        it 'チャットが表示されている' do
                                            expect(page).to have_content 'チャット'
                                        end

                                        it '売却ユーザで送信したチャットが表示されている' do
                                            sleep 2
                                            expect(page).to have_content 'テストメッセージ'
                                        end

                                        context '購入ユーザでチャットを送信する' do
                                            before do
                                                fill_in 'item_trade_chat_message',	with: "購入テストメッセージ" 
                                                sleep 1
                                                click_button '送信'
                                                sleep 1
                                            end

                                            it 'チャットが反映されている' do
                                                sleep 2
                                                expect(page).to have_content '購入テストメッセージ'
                                            end
                                        end

                                        context '購入ユーザで定形文を送信する' do
                                            before do
                                                find("#fixed_phrases_dropdown").click
                                                sleep 2
                                                find(".dropdown-item").click
                                                sleep 2
                                            end

                                            it '定形文が反映されている' do
                                                sleep 2
                                                expect(page).to have_content buy_fixed_phrase.text
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

