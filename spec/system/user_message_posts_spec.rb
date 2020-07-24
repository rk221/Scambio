require 'rails_helper'

RSpec.describe UserMessagePost, type: :system do
    let!(:sale_user){create(:sale_user)}
    let!(:buy_user){create(:buy_user)}

    let!(:game){create(:game)}
    let!(:item_genre){create(:item_genre)}
    let!(:item_genre_game){create(:item_genre_game, item_genre: item_genre, game: game, enable: true)}
    let!(:buy_item){create(:buy_item, item_genre: item_genre, game: game)}
    let!(:sale_item){create(:sale_item, item_genre: item_genre, game: game)}

    let!(:buy_user_game_rank){create(:user_game_rank, user: buy_user, game: game)}
    let!(:sale_user_game_rank){create(:user_game_rank, user: sale_user, game: game)}

    describe 'UserMessagePost' do
        include_context 'when sale user is logging in'
            
        context 'when registed a item trade' do
            let(:item_trade){build(:item_trade, user: sale_user, game: game, buy_item: buy_item, sale_item: sale_item, enable: true, numeric_of_trade_deadline: 1, user_game_rank: sale_user_game_rank)}

            include_context 'when registering a item trade'

            include_context 'when user is logging out'
            include_context 'when buy user is logging in'

            context 'when buying' do
                before do
                    click_link t_navbar(:games)
                    click_link t('games.index.item_trades')
                    click_link t('games.item_trades.index.buy_queue')
                end

                include_context 'when user is logging out'
                include_context 'when sale user is logging in'

                context 'with bought message' do
                    before do
                        click_link t('users.show.user_message_posts')
                    end

                    it 'received message list is displayed' do
                        main_to_expect.to have_content t('users.user_message_posts.index.title')
                    end

                    it 'received messages is displayed' do
                        main_to_expect.to have_content t_model_attribute_name(UserMessagePost, :subject)
                        main_to_expect.to have_content t_model_attribute_name(UserMessagePost, :created_at)
                        main_to_expect.to have_content t('users.user_message_posts.shared.sell_item_trade.subject')
                    end

                    context 'when transitioning to details of user message post' do
                        before do
                            find('tr[data-href]').click
                        end

                        it 'received message is displayed' do
                            main_to_expect.to have_content t_model_attribute_name(UserMessagePost, :subject)
                            main_to_expect.to have_content t_model_attribute_name(UserMessagePost, :created_at)
                            main_to_expect.to have_content t_model_attribute_name(UserMessagePost, :message)
                            main_to_expect.to have_content t('users.user_message_posts.shared.sell_item_trade.subject')
                            main_to_expect.to have_content t('users.user_message_posts.shared.sell_item_trade.message')
                            main_to_expect.to have_content t_link_to(:show)
                        end
                    end
                end

                context 'when transitioning to details of reaction wait item trade' do
                    before do
                        click_link t_link_to(:show)
                    end

                    context 'when approve an item trade' do
                        before do
                            click_link t('users.user_item_trades.show.approve')
                        end

                        include_context 'when user is logging out'
                        include_context 'when buy user is logging in'

                        context 'when transitioning to details of item trade queue' do
                            before do
                                click_link t('users.show.item_trade_queues')
                                click_link t_link_to(:show)
                            end

                            include_context 'when user is logging out'
                            include_context 'when sale user is logging in'

                            context 'when transitioning to details of enable item trade' do
                                before do
                                    click_link t_navbar(:mypage)
                                    click_link t_link_to(:show)
                                end

                                context 'when complete the item trade' do
                                    before do
                                        click_link t('users.user_item_trades.show.edit_buy')
                                    end

                                    context 'when evaluate' do
                                        before do
                                            find('label[for=good]').click
                                            click_button t_submit(:send)
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