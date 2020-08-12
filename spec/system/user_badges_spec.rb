require 'rails_helper'

RSpec.describe UserBadge, type: :system do
    let!(:sale_user){create(:sale_user)}
    let!(:buy_user){create(:buy_user)}

    let!(:game){create(:game)}
    let!(:item_genre){create(:item_genre)}
    let!(:item_genre_game){create(:item_genre_game, item_genre: item_genre, game: game, enable: true)}
    let!(:buy_item){create(:buy_item, item_genre: item_genre, game: game)}
    let!(:sale_item){create(:sale_item, item_genre: item_genre, game: game)}

    let!(:buy_user_game_rank){create(:user_game_rank, user: buy_user, game: game)}
    let!(:sale_user_game_rank){create(:user_game_rank, user: sale_user, game: game)}

    let!(:badge){create(:badge, game: game, item_trade_count_condition: 1, rank_condition: 0)}

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
                    click_button t('games.item_trades.index.buy_queue')
                end

                include_context 'when user is logging out'
                include_context 'when sale user is logging in'

                context 'when approve' do
                    before do
                        click_link t_link_to(:show)
                        click_button t('users.user_item_trades.show.approve')
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

                        context 'when end trade' do
                            before do
                                click_link t_navbar(:mypage)
                                click_link t_link_to(:show)
                                click_link t('users.user_item_trades.show.edit_buy')
                                find('label[for=good]').click
                                click_button t_submit(:send)
                            end

                            context 'when transitioning to user badges' do 
                                before do
                                    click_link t_navbar(:mypage)
                                    click_link t("users.show.badges")
                                end

                                it 'an user_badges is displayed' do 
                                    main_to_expect.to have_content t('users.badges.index.title')
                                    main_to_expect.to have_content t('users.badges.index.wearable_badges')
                                end

                                context 'when transitioning to edit of user badges' do 
                                    before do 
                                        click_link t('users.badges.index.wear_badges')
                                    end

                                    it 'an edit of user_badges is displayed' do 
                                        main_to_expect.to have_content t('users.badges.edit.title')
                                        main_to_expect.to have_content badge.name
                                    end

                                    context 'when update user badges' do 
                                        before do 
                                            check badge.name
                                            click_button t_submit(:submit)
                                        end

                                        it 'an user_badges is displayed' do 
                                            main_to_expect.to have_content t('users.badges.index.title')
                                            main_to_expect.to have_content t('users.badges.index.wearable_badges')
                                            main_to_expect.to have_content t('users.badges.index.wearing_badges')
                                            main_to_expect.to have_content badge.name
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