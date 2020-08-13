require 'rails_helper'

RSpec.describe ItemTradeChat, type: :system do
    let!(:general_user){create(:general_user)}
    let!(:admin_user){create(:admin_user)}
    let!(:sale_user){create(:sale_user)}
    let!(:buy_user){create(:buy_user)}

    let!(:game){create(:game)}
    let!(:item_genre){create(:item_genre)}
    let!(:item_genre_game){create(:item_genre_game, item_genre: item_genre, game: game, enable: true)}
    let!(:buy_item){create(:buy_item, item_genre: item_genre, game: game)}
    let!(:sale_item){create(:sale_item, item_genre: item_genre, game: game)}

    let!(:buy_user_game_rank){create(:user_game_rank, user: buy_user, game: game)}
    let!(:sale_user_game_rank){create(:user_game_rank, user: sale_user, game: game)}

    let!(:sale_fixed_phrase){create(:fixed_phrase, user: sale_user)}
    let!(:buy_fixed_phrase){create(:fixed_phrase, user: buy_user)}

    describe 'Item Trade Chat' do
        include_context 'when sale user is logging in'
            
        let(:item_trade){build(:item_trade, user: sale_user, game: game, buy_item: buy_item, sale_item: sale_item, enable: true, numeric_of_trade_deadline: 1, user_game_rank: sale_user_game_rank)}
        include_context 'when registering a item trade'

        include_context 'when user is logging out'
        include_context 'when buy user is logging in'

        context 'when buying' do
            before do
                click_link t_navbar(:games)
                click_link t("games.index.item_trades")
                click_button t("games.item_trades.index.buy_queue")
            end

            include_context 'when user is logging out'
            include_context 'when sale user is logging in'

            context 'when approving a item trade' do
                before do
                    click_link t_link_to(:show)
                    click_button t('users.item_trades.show.approve')
                end

                it 'chats is displayed' do
                    main_to_expect.to have_content t('users.shared.item_trade_chat.chat')
                end

                context 'when sending a fixed phrase' do
                    before do
                        find("#fixed_phrases_dropdown").click
                        sleep 2
                        find(".dropdown-item").click
                        sleep 2
                    end

                    it 'a fixed phrase is displayed' do
                        sleep 2
                        main_to_expect.to have_content sale_fixed_phrase.text
                    end
                end

                context 'when sending a chat' do
                    before do
                        fill_in 'item_trade_chat_message',	with: "テストメッセージ" 
                        sleep 1
                        click_button t_submit(:send)
                    end

                    it 'a chat is displayed' do
                        sleep 2
                        main_to_expect.to have_content 'テストメッセージ'
                    end

                    context 'when buy user is logging in' do
                        include_context 'when user is logging out'
                        include_context 'when buy user is logging in'

                        context 'when transitioning to detail of item trade queue' do
                            before do
                                click_link t('users.show.item_trade_queues')
                                click_link t_link_to(:show)
                            end

                            it 'chats is displayed' do
                                main_to_expect.to have_content t('users.shared.item_trade_chat.chat')
                            end

                            it 'a chat is displayed' do
                                sleep 2
                                main_to_expect.to have_content 'テストメッセージ'
                            end

                            context 'when sending a chat' do
                                before do
                                    fill_in 'item_trade_chat_message',	with: "購入テストメッセージ" 
                                    sleep 1
                                    click_button t_submit(:send)
                                end

                                it 'a chat is displayed' do
                                    sleep 2
                                    main_to_expect.to have_content '購入テストメッセージ'
                                end
                            end

                            context 'when sending a fixed phrase' do
                                before do
                                    find("#fixed_phrases_dropdown").click
                                    sleep 2
                                    find(".dropdown-item").click
                                    sleep 2
                                end

                                it 'a fixed phrase is displayed' do
                                    sleep 2
                                    main_to_expect.to have_content buy_fixed_phrase.text
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

