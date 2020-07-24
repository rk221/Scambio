""" 
    ItemTradeに関するshared_context
    予め、letでitem_tradeを定義しておくこと
"""
shared_context 'when sale user is logging in' do
    before do
        visit new_user_session_path
        fill_in t_model_attribute_name(User, 'email'), with: sale_user.email
        fill_in t_model_attribute_name(User, 'password'), with: sale_user.password
        click_button t('devise.sessions.new.sign_in')
    end
end

shared_context 'when buy user is logging in' do
    before do
        visit new_user_session_path
        fill_in t_model_attribute_name(User, 'email'), with: buy_user.email
        fill_in t_model_attribute_name(User, 'password'), with: buy_user.password
        click_button t('devise.sessions.new.sign_in')
    end
end

shared_context 'when registering a item trade' do
    before do
        click_link t_navbar(:games)
        click_link t('games.index.item_trades')
        click_link t('games.item_trades.index.new_trade')

        select item_trade.buy_item.item_genre.name, from: t_model_attribute_name(RegistItemTradeForm, :buy_item_genre_id)
        fill_in t_model_attribute_name(RegistItemTradeForm, :buy_item_name), with: item_trade.buy_item.name
        fill_in t_model_attribute_name(RegistItemTradeForm, :buy_item_quantity), with: item_trade.buy_item_quantity

        select item_trade.sale_item.item_genre.name, from: t_model_attribute_name(RegistItemTradeForm, :sale_item_genre_id)
        fill_in t_model_attribute_name(RegistItemTradeForm, :sale_item_name), with: item_trade.sale_item.name
        fill_in t_model_attribute_name(RegistItemTradeForm, :sale_item_quantity), with: item_trade.sale_item_quantity
        fill_in t_model_attribute_name(RegistItemTradeForm, :trade_deadline), with: 1
        click_button t_submit(:create)
    end
end

shared_examples 'item trades is displayed' do
    it 'item trades is displayed' do
        expect(find('.item_trades')).to have_content ItemTrade.human_attribute_name(:buy_item_genre_name) # 購入アイテムジャンル名
        expect(find('.item_trades')).to have_content item_trade.buy_item.item_genre.name
        expect(find('.item_trades')).to have_content ItemTrade.human_attribute_name(:sale_item_genre_name) # 売却アイテムジャンル名
        expect(find('.item_trades')).to have_content item_trade.sale_item.item_genre.name
        expect(find('.item_trades')).to have_content ItemTrade.human_attribute_name(:buy_item_name) # 購入アイテム名
        expect(find('.item_trades')).to have_content item_trade.buy_item.name
        expect(find('.item_trades')).to have_content ItemTrade.human_attribute_name(:sale_item_name) # 売却アイテム名
        expect(find('.item_trades')).to have_content item_trade.sale_item.name
        expect(find('.item_trades')).to have_content ItemTrade.human_attribute_name(:buy_item_quantity) # 購入アイテム数量
        expect(find('.item_trades')).to have_content item_trade.buy_item_quantity
        expect(find('.item_trades')).to have_content ItemTrade.human_attribute_name(:sale_item_quantity) # 売却アイテム数量
        expect(find('.item_trades')).to have_content item_trade.sale_item_quantity
    end
end

shared_examples 'item trades is not displayed' do
    it 'item trades is not displayed' do
        expect(find('.item_trades')).to_not have_content ItemTrade.human_attribute_name(:buy_item_genre_name) # 購入アイテムジャンル名
        expect(find('.item_trades')).to_not have_content item_trade.buy_item.item_genre.name
        expect(find('.item_trades')).to_not have_content ItemTrade.human_attribute_name(:sale_item_genre_name) # 売却アイテムジャンル名
        expect(find('.item_trades')).to_not have_content item_trade.sale_item.item_genre.name
        expect(find('.item_trades')).to_not have_content ItemTrade.human_attribute_name(:buy_item_name) # 購入アイテム名
        expect(find('.item_trades')).to_not have_content item_trade.buy_item.name
        expect(find('.item_trades')).to_not have_content ItemTrade.human_attribute_name(:sale_item_name) # 売却アイテム名
        expect(find('.item_trades')).to_not have_content item_trade.sale_item.name
        expect(find('.item_trades')).to_not have_content ItemTrade.human_attribute_name(:buy_item_quantity) # 購入アイテム数量
        expect(find('.item_trades')).to_not have_content item_trade.buy_item_quantity
        expect(find('.item_trades')).to_not have_content ItemTrade.human_attribute_name(:sale_item_quantity) # 売却アイテム数量
        expect(find('.item_trades')).to_not have_content item_trade.sale_item_quantity
    end
end

shared_examples 'trade deadline is displayed' do
    it 'trade deadline is displayed' do
        main_to_expect.to have_content ItemTrade.human_attribute_name(:trade_deadline) # 取引期限
    end
end

shared_examples 'trade deadline is not displayed' do
    it 'trade deadline is not displayed' do
        main_to_expect.to_not have_content ItemTrade.human_attribute_name(:trade_deadline) # 取引期限
    end
end

shared_examples 'item trade is displayed in item trade list' do
    before do
        click_link t_navbar(:games)
        click_link t('games.index.item_trades')
    end

    it "item trade list is displayed" do
        main_to_expect.to have_content t('games.item_trades.index.title')
    end

    include_examples 'item trades is displayed'
    include_examples 'trade deadline is displayed'
end

shared_examples 'item trade is not displayed in item trade list' do
    before do
        click_link t_navbar(:games)
        click_link t('games.index.item_trades')
    end

    it "item trade list is displayed" do
        main_to_expect.to have_content t('games.item_trades.index.title')
    end

    include_examples 'item trades is not displayed'
    include_examples 'trade deadline is not displayed'
end

shared_examples 'item trade is displayed in reaction item trade list' do
    before do
        within '#nav' do
            click_link t_navbar(:mypage)
        end
    end
    # 反応待ちにアイテムトレードが表示されている
    include_examples 'item trades is displayed'
    include_examples 'trade deadline is not displayed'
end

shared_examples 'item trade is enabled' do
    context 'when transitioning to item trade queues' do
        before do
            within '#nav' do
                click_link t_navbar(:mypage)
            end
            click_link t('users.show.item_trade_queues')
        end

        it 'a item trade queues is displayed' do
            main_to_expect.to have_content t('item_trade_queues.index.title')
        end

        it 'enable item trade is displayed' do
            main_to_expect.to have_content t_link_to(:show)
        end

        it_behaves_like 'item trades is displayed'
        it_behaves_like 'trade deadline is not displayed'
    end
end

shared_examples 'item trade is disabled' do
    context 'when transitioning to item trade queues' do
        before do
            within '#nav' do
                click_link t_navbar(:mypage)
            end
            click_link t('users.show.item_trade_queues')
        end

        it 'a item trade queues is displayed' do
            main_to_expect.to have_content t('item_trade_queues.index.title')
        end

        it 'item trade is not displayed' do
            main_to_expect.to_not have_content t_link_to(:show)
        end

        it_behaves_like 'item trades is not displayed'
        it_behaves_like 'trade deadline is not displayed'
    end
end

shared_examples 'item trade is awaiting evaluation' do
    before do
        within '#nav' do
            click_link t_navbar(:mypage)
        end
    end

    it_behaves_like 'item trades is not displayed'
    it_behaves_like 'trade deadline is not displayed'

    context 'when transitioning to user item trade list' do
        before do
            click_link t('users.show.user_item_trades')
        end

        it 'user item trade list is displayed' do
            main_to_expect.to have_content t('users.user_item_trades.index.title')
        end

        it 'a link to show of item trade' do
            main_to_expect.to have_content t_link_to(:show)
        end

        it_behaves_like 'item trades is displayed'
        it_behaves_like 'trade deadline is not displayed'

        context 'when transitioning to detail of user item trade' do
            before do
                click_link t_link_to(:show)
            end
            
            it 'a detail of user item trade is displayed' do
                main_to_expect.to have_content t("users.user_item_trades.show.title")
            end

            it 'item trade is waiting for the other party to evaluate' do
                main_to_expect.to have_content t('users.user_item_trades.show.now_state')
                main_to_expect.to have_content t('users.user_item_trades.show.your_evaluate_wait')
            end

            it_behaves_like 'item trades is displayed'
            it_behaves_like 'trade deadline is not displayed'
        end
    end
end
