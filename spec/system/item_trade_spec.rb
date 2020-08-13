require 'rails_helper'

RSpec.describe ItemTrade, type: :system do
    let!(:general_user){create(:general_user)}
    let!(:admin_user){create(:admin_user)}
    let!(:sale_user){create(:sale_user)}
    let!(:buy_user){create(:buy_user)}

    let!(:game){create(:game)}
    let!(:item_genre){create(:item_genre)}
    let!(:item_genre_game){create(:item_genre_game, item_genre: item_genre, game: game, enable: true)}
    let!(:buy_item){create(:buy_item, item_genre: item_genre, game: game)}
    let!(:sale_item){create(:sale_item, item_genre: item_genre, game: game)}

    let!(:user_game_rank){create(:user_game_rank, user: admin_user, game: game)}
    let!(:buy_user_game_rank){create(:user_game_rank, user: buy_user, game: game)}
    let!(:sale_user_game_rank){create(:user_game_rank, user: sale_user, game: game)}

    describe 'Item Trade' do 
        let(:login_user){general_user}
        include_context 'when user is logging in'

        describe 'Create' do
            let(:item_trade){build(:item_trade, user: login_user, game: game, buy_item: buy_item, sale_item: sale_item, enable: true, numeric_of_trade_deadline: 1, user_game_rank: user_game_rank)}
            before do
                click_link t_navbar(:games)
                click_link t('games.index.item_trades')
                click_link t('games.item_trades.index.new_trade')
            end
                
            it 'a create of item trade is displayed' do 
                main_to_expect.to have_content t('games.item_trades.new.title')
            end

            context 'when create valid item trade' do
                before do
                    select item_trade.buy_item.item_genre.name, from: t_model_attribute_name(RegistItemTradeForm, :buy_item_genre_id)
                    fill_in t_model_attribute_name(RegistItemTradeForm, :buy_item_name), with: item_trade.buy_item.name
                    fill_in t_model_attribute_name(RegistItemTradeForm, :buy_item_quantity), with: item_trade.buy_item_quantity

                    select item_trade.sale_item.item_genre.name, from: t_model_attribute_name(RegistItemTradeForm, :sale_item_genre_id)
                    fill_in t_model_attribute_name(RegistItemTradeForm, :sale_item_name), with: item_trade.sale_item.name
                    fill_in t_model_attribute_name(RegistItemTradeForm, :sale_item_quantity), with: item_trade.sale_item_quantity
                    fill_in t_model_attribute_name(RegistItemTradeForm, :trade_deadline), with: 1
                    click_button t_submit(:create)
                end

                it_behaves_like 'item trades is displayed'
            end

            context 'when create invalid item trade' do
                before do
                    select item_trade.buy_item.item_genre.name, from: t_model_attribute_name(RegistItemTradeForm, :buy_item_genre_id)
                    fill_in t_model_attribute_name(RegistItemTradeForm, :buy_item_name), with: ""
                    fill_in t_model_attribute_name(RegistItemTradeForm, :buy_item_quantity), with: ""

                    select item_trade.sale_item.item_genre.name, from: t_model_attribute_name(RegistItemTradeForm, :sale_item_genre_id)
                    fill_in t_model_attribute_name(RegistItemTradeForm, :sale_item_name), with: ""
                    fill_in t_model_attribute_name(RegistItemTradeForm, :sale_item_quantity), with: ""
                    fill_in t_model_attribute_name(RegistItemTradeForm, :trade_deadline), with: 0
                    click_button t_submit(:create)
                end

                it 'a create of item trade is displayed' do 
                    main_to_expect.to have_content t('games.item_trades.new.title')
                end
            end
        end

        describe 'Edit' do
            let(:item_trade){build(:item_trade, user: login_user, game: game, buy_item: buy_item, sale_item: sale_item, enable: true, numeric_of_trade_deadline: 1, user_game_rank: user_game_rank)}
            include_context 'when registering a item trade'

            context 'when transitioning to edit of item trade' do
                before do
                    click_link t_navbar(:games)
                    click_link t('games.index.item_trades')
                    click_link t_link_to(:show)
                    click_link t_link_to(:edit)
                end

                it 'a edit of item trade is displayed' do 
                    main_to_expect.to have_content t('games.item_trades.edit.title')
                end

                context 'when update valid item trade' do
                    let(:update_item_trade){build(:item_trade, buy_item_quantity: 100, sale_item_quantity: 20)}
                    before do
                        fill_in t_model_attribute_name(ItemTrade, :buy_item_quantity), with: update_item_trade.buy_item_quantity
                        fill_in t_model_attribute_name(ItemTrade, :sale_item_quantity), with: update_item_trade.sale_item_quantity
                        fill_in t_model_attribute_name(ItemTrade, :trade_deadline), with: 3
                        click_button t_submit(:update)
                    end

                    it 'updated item trade to detail of your item trade is displayed' do
                        main_to_expect.to have_content t('users.item_trades.show.title')
                        main_to_expect.to have_content update_item_trade.buy_item_quantity
                        main_to_expect.to have_content update_item_trade.sale_item_quantity
                    end
                end

                context 'when update invalid item trade' do
                    before do
                        fill_in t_model_attribute_name(ItemTrade, :buy_item_quantity), with: ""
                        fill_in t_model_attribute_name(ItemTrade, :sale_item_quantity), with: ""
                        fill_in t_model_attribute_name(ItemTrade, :trade_deadline), with: ""
                        click_button t_submit(:update)
                    end

                    it 'a edit of item trade is displayed' do 
                        main_to_expect.to have_content t('games.item_trades.edit.title')
                    end
                end
            end
        end

        describe 'Destroy' do
            let(:item_trade){build(:item_trade, user: login_user, game: game, buy_item: buy_item, sale_item: sale_item, enable: true, numeric_of_trade_deadline: 1, user_game_rank: user_game_rank)}
            include_context 'when registering a item trade'

            context 'when transitioning to detail of user item trade' do
                before do
                    click_link t_navbar(:games)
                    click_link t("games.index.item_trades")
                    click_link t_link_to(:show)
                end

                context 'when destroy item trade' do
                    before do
                        click_link t_link_to(:destroy)
                        accept_confirm
                    end


                    it 'user item trade list is displayed' do
                        main_to_expect.to have_content t('users.item_trades.index.title')
                    end

                    it 'item trade is disabled' do
                        main_to_expect.to have_content t('users.item_trades.index.edit')
                    end

                    it_behaves_like 'item trades is displayed'
                    it_behaves_like 'trade deadline is not displayed'
                    it_behaves_like 'item trade is not displayed in item trade list'
                end
            end
        end
    end


    describe 'Trade' do
        include_context 'when sale user is logging in'
            
        let(:item_trade){build(:item_trade, user: sale_user, game: game, buy_item: buy_item, sale_item: sale_item, enable: true, numeric_of_trade_deadline: 1, user_game_rank: sale_user_game_rank)}

        include_context 'when registering a item trade'

        it_behaves_like 'item trade is displayed in item trade list'

        include_context 'when user is logging out'
        include_context 'when buy user is logging in'

        context 'when buying' do
            before do
                click_link t_navbar(:games)
                click_link t("games.index.item_trades")
                click_button t("games.item_trades.index.buy_queue")
            end

            it 'a link to detail of item trade queue is displayed' do
                main_to_expect.to have_content t('users.item_trade_queues.show.title')
            end

            it 'item trade awaiting response' do
                main_to_expect.to have_content t("users.item_trade_queues.show.now_state")
                main_to_expect.to have_content t("users.item_trade_queues.show.state_wait_reaction")
            end

            it_behaves_like 'item trades is displayed'

            context 'when sale user is logging in' do
                include_context 'when user is logging out'
                include_context 'when sale user is logging in'

                it_behaves_like 'item trade is displayed in reaction item trade list'

                context 'when transitioning to detail of reaction item trade' do
                    before do
                        click_link t_link_to(:show)
                    end

                    it 'a detail of user item trade is displayed' do
                        main_to_expect.to have_content t('users.item_trades.show.title')
                    end

                    it 'item trade awaiting response' do
                        main_to_expect.to have_button t('users.item_trades.show.approve')
                        main_to_expect.to have_button t('users.item_trades.show.disapprove')
                    end

                    it_behaves_like 'item trades is displayed'
                    it_behaves_like 'trade deadline is not displayed'

                    context 'when approving a item trade' do
                        before do
                            click_button t('users.item_trades.show.approve')
                        end

                        it 'a detail of user item trade is displayed' do
                            main_to_expect.to have_content t("users.item_trades.show.title")
                        end

                        it 'a link to end item trade is displayed' do
                            main_to_expect.to have_content t('users.item_trades.show.edit_buy')
                        end

                        it_behaves_like 'item trades is displayed'
                        it_behaves_like 'trade deadline is not displayed'

                        context 'when buy user is logging in' do
                            include_context 'when user is logging out'
                            include_context 'when buy user is logging in'

                            context 'when transitioning to item trade queues' do
                                before do
                                    click_link t('users.show.item_trade_queues')
                                end

                                it 'a item trade queues is displayed' do
                                    main_to_expect.to have_content t('users.item_trade_queues.index.title')
                                end

                                it 'enable item trade is displayed' do
                                    main_to_expect.to have_content t_link_to(:show)
                                end

                                it_behaves_like 'item trades is displayed'
                                it_behaves_like 'trade deadline is not displayed'

                                context 'when transitioning to detail of item trade queue' do
                                    before do
                                        click_link t_link_to(:show)
                                    end

                                    it 'a detail of item trade queue is displayed' do
                                        main_to_expect.to have_content t('users.item_trade_queues.show.title')
                                    end

                                    it 'item trade is during trade' do
                                        main_to_expect.to have_content t('users.item_trade_queues.show.state_during_trade')
                                        main_to_expect.to have_content t('users.item_trade_queues.show.edit_sale')
                                    end

                                    it_behaves_like 'item trades is displayed'
                                    it_behaves_like 'trade deadline is not displayed'

                                    context 'when sale user is logging in' do
                                        include_context 'when user is logging out'
                                        include_context 'when sale user is logging in'

                                        context 'when transitioning to detail of reaction item trade' do
                                            before do
                                                click_link t_link_to(:show)
                                            end

                                            it 'a detail of user item trade is displayed' do
                                                main_to_expect.to have_content t("users.item_trades.show.title")
                                            end

                                            it 'item trade is during trade' do
                                                main_to_expect.to have_content t("users.item_trades.show.state_during_trade")
                                                main_to_expect.to have_content t("users.item_trades.show.edit_buy")
                                            end

                                            it_behaves_like 'item trades is displayed'
                                            it_behaves_like 'trade deadline is not displayed'

                                            context 'when end item trade of buyer first' do
                                                before do
                                                    click_link t('users.item_trades.show.edit_buy')
                                                end

                                                it 'item trade detail is displayed' do
                                                    main_to_expect.to have_content t('item_trade_details.edit_buy.title')
                                                    main_to_expect.to have_content t('item_trade_details.shared.edit.good')
                                                    main_to_expect.to have_content t('item_trade_details.shared.edit.normal')
                                                    main_to_expect.to have_content t('item_trade_details.shared.edit.bad')
                                                end

                                                context 'when evaluate good' do
                                                    before do
                                                        find('label[for=good]').click
                                                        click_button t_submit(:send)
                                                    end

                                                    it 'end item trade message is displayed' do
                                                        expect(find('#flash')).to have_content t('item_trade_details.buy_evaluate.success_message')
                                                        main_to_expect.to have_content t('users.show.title')
                                                    end

                                                    it_behaves_like 'item trade is awaiting evaluation'
                                                        
                                                    context 'when buy user is logging in' do
                                                        include_context 'when user is logging out'
                                                        include_context 'when buy user is logging in'
                                                        it_behaves_like 'item trade is enabled'
                                                    end
                                                end

                                                context 'when evaluate normal' do
                                                    before do
                                                        find('label[for=normal]').click
                                                        click_button t_submit(:send)
                                                    end

                                                    it 'end item trade message is displayed' do
                                                        expect(find('#flash')).to have_content t('item_trade_details.buy_evaluate.success_message')
                                                        main_to_expect.to have_content t('users.show.title')
                                                    end

                                                    it_behaves_like 'item trade is awaiting evaluation'
                                                        
                                                    context 'when buy user is logging in' do
                                                        include_context 'when user is logging out'
                                                        include_context 'when buy user is logging in'
                                                        it_behaves_like 'item trade is enabled'
                                                    end
                                                end

                                                context 'when evaluate bad' do
                                                    before do
                                                        find('label[for=bad]').click
                                                        click_button t_submit(:send)
                                                    end

                                                    it 'end item trade message is displayed' do
                                                        expect(find('#flash')).to have_content t('item_trade_details.buy_evaluate.success_message')
                                                        main_to_expect.to have_content t('users.show.title')
                                                    end

                                                    it_behaves_like 'item trade is awaiting evaluation'
                                                        
                                                    context 'when buy user is logging in' do
                                                        include_context 'when user is logging out'
                                                        include_context 'when buy user is logging in'
                                                        it_behaves_like 'item trade is enabled'
                                                    end
                                                end
                                            end

                                            context 'when end item trade of seller first' do
                                                before do
                                                    click_link t('users.item_trades.show.edit_buy')
                                                end

                                                it 'item trade detail is displayed' do
                                                    main_to_expect.to have_content t('item_trade_details.edit_buy.title')
                                                    main_to_expect.to have_content t('item_trade_details.shared.edit.good')
                                                    main_to_expect.to have_content t('item_trade_details.shared.edit.normal')
                                                    main_to_expect.to have_content t('item_trade_details.shared.edit.bad')
                                                end

                                                context 'when evaluate good' do
                                                    before do
                                                        find('label[for=good]').click
                                                        click_button t_submit(:send)
                                                    end

                                                    it 'end item trade message is displayed' do
                                                        expect(find('#flash')).to have_content t('item_trade_details.buy_evaluate.success_message')
                                                        main_to_expect.to have_content t('users.show.title')
                                                    end

                                                    it_behaves_like 'item trade is awaiting evaluation'
                                                        
                                                    context 'when buy user is logging in' do
                                                        include_context 'when user is logging out'
                                                        include_context 'when buy user is logging in'
                                                        it_behaves_like 'item trade is enabled'
                                                    end
                                                end

                                                context 'when evaluate normal' do
                                                    before do
                                                        find('label[for=normal]').click
                                                        click_button t_submit(:send)
                                                    end

                                                    it 'end item trade message is displayed' do
                                                        expect(find('#flash')).to have_content t('item_trade_details.buy_evaluate.success_message')
                                                        main_to_expect.to have_content t('users.show.title')
                                                    end

                                                    it_behaves_like 'item trade is awaiting evaluation'
                                                        
                                                    context 'when buy user is logging in' do
                                                        include_context 'when user is logging out'
                                                        include_context 'when buy user is logging in'
                                                        it_behaves_like 'item trade is enabled'
                                                    end
                                                end

                                                context 'when evaluate bad' do
                                                    before do
                                                        find('label[for=bad]').click
                                                        click_button t_submit(:send)
                                                    end

                                                    it 'end item trade message is displayed' do
                                                        expect(find('#flash')).to have_content t('item_trade_details.buy_evaluate.success_message')
                                                        main_to_expect.to have_content t('users.show.title')
                                                    end

                                                    it_behaves_like 'item trade is awaiting evaluation'
                                                        
                                                    context 'when buy user is logging in' do
                                                        include_context 'when user is logging out'
                                                        include_context 'when buy user is logging in'
                                                        it_behaves_like 'item trade is enabled'
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end

                    context 'when disapproving a item trade' do
                        before do
                            click_button t('users.item_trades.show.disapprove')
                        end

                        it 'a edit of item trade is displayed' do 
                            main_to_expect.to have_content t('games.item_trades.edit.title')
                        end


                        context 'when buy user is logging in' do
                            include_context 'when user is logging out'
                            include_context 'when buy user is logging in'
                            it_behaves_like 'item trade is disabled'
                        end

                        it_behaves_like 'item trade is disabled'
                    end
                end
            end
        end
    end
end