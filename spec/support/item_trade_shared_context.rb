""" 
    ItemTradeに関するshared_context
    予め、letでitem_tradeをletで定義しておくこと
"""
# 購入ユーザを予めletで定義する必要あり
shared_context '売却ユーザがログイン状態になる' do |state|
    before do
        click_link 'ログアウト' if state == :login
        visit new_user_session_path if state == :logout

        fill_in 'メールアドレス', with: sale_user.email
        fill_in 'パスワード', with: sale_user.password
        click_button 'ログイン'
    end

    it '「ログインしました。」とフラッシュメッセージが表示されている' do
        expect(page).to have_content 'ログインしました。';
    end
end

# 購入ユーザを予めletで定義する必要あり
shared_context '購入ユーザがログイン状態になる' do |state|
    before do
        click_link 'ログアウト' if state == :login
        visit new_user_session_path if state == :logout

        fill_in 'メールアドレス', with: buy_user.email
        fill_in 'パスワード', with: buy_user.password
        click_button 'ログイン'
    end

    it '「ログインしました。」とフラッシュメッセージが表示されている' do
        expect(page).to have_content 'ログインしました。';
    end
end

shared_examples 'アイテムトレードの要素が表示されている' do
    it 'アイテムトレードの要素が表示されている' do
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

shared_examples 'アイテムトレードの要素が表示されていない' do
    it 'アイテムトレードの要素が表示されていない' do
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

shared_examples '取引期限が表示されている' do
    it '取引期限が表示されている' do
        expect(find('body')).to have_content ItemTrade.human_attribute_name(:trade_deadline) # 取引期限
    end
end

shared_examples '取引期限が表示されていない' do
    it '取引期限が表示されていない' do
        expect(find('body')).to_not have_content ItemTrade.human_attribute_name(:trade_deadline) # 取引期限
    end
end

shared_context '反応待ちアイテムトレードに取引が表示されている' do
    before do
        click_link 'マイページ'    
    end

    it 'マイページに遷移している' do
        expect(find('body')).to have_content 'マイページ'
        expect(find('body')).to have_content '反応待ちアイテムトレード一覧'
    end
    # 反応待ちにアイテムトレードが表示されている
    include_examples 'アイテムトレードの要素が表示されている'
    include_examples '取引期限が表示されていない'
end

shared_context 'アイテムトレード一覧で取引が表示されていることを確認する' do
    before do
        click_link 'ゲーム'
        click_link 'アイテムトレード一覧'
    end

    it "アイテムトレード一覧が表示されている" do
        expect(find('body')).to have_content 'アイテムトレード一覧'
    end

    include_examples 'アイテムトレードの要素が表示されている'
    include_examples '取引期限が表示されている'
end

shared_context 'アイテムトレード一覧で取引が非表示になっていることを確認する' do
    before do
        click_link 'ゲーム'
        click_link 'アイテムトレード一覧'
    end

    it "アイテムトレード一覧が表示されている" do
        expect(find('body')).to have_content 'アイテムトレード一覧'
    end

    include_examples 'アイテムトレードの要素が表示されていない'
    include_examples '取引期限が表示されていない'
end

# 先にログイン必須
shared_context 'アイテムトレードを登録する' do
    before do
        click_link 'ゲーム'
        click_link 'アイテムトレード一覧'
        click_link '取引登録'

        select item_trade.buy_item.item_genre.name, from: '購入アイテムジャンル'
        fill_in '購入アイテム名', with: item_trade.buy_item.name
        fill_in '購入数量', with: item_trade.buy_item_quantity

        select item_trade.sale_item.item_genre.name, from: '売却アイテムジャンル'
        fill_in '売却アイテム名', with: item_trade.sale_item.name
        fill_in '売却数量', with: item_trade.sale_item_quantity
        fill_in '取引期限', with: 1
        click_button '登録'
    end

    it 'あなたのアイテムトレード一覧が表示されている' do
        expect(find('body')).to have_content 'あなたのアイテムトレード一覧'
    end

    include_examples 'アイテムトレードの要素が表示されている'
    include_examples '取引期限が表示されている'

    it '取引が有効な状態で表示されている' do
        expect(find('body')).to have_content '詳細'
    end

    it_behaves_like 'アイテムトレード一覧で取引が表示されていることを確認する'
end

shared_examples '購入ユーザ側で、取引が無効状態になっている' do |user_state|
    include_context '購入ユーザがログイン状態になる', user_state

    context '購入待ちアイテムトレード一覧に遷移する' do
        before do
            click_link '購入待ちアイテムトレード一覧'
        end

        it 'アイテムトレード購入待ち一覧が表示されている' do
            expect(find('body')).to have_content 'アイテムトレード購入待ち一覧'
        end

        include_examples 'アイテムトレードの要素が表示されていない'
        include_examples '取引期限が表示されていない'
    end
end

shared_context '購入ユーザ側で、取引が有効状態になっている' do |user_state|
    include_context '購入ユーザがログイン状態になる', user_state

    context '購入待ちアイテムトレード一覧に遷移する' do
        before do
            click_link '購入待ちアイテムトレード一覧'
        end

        it 'アイテムトレード購入待ち一覧が表示されている' do
            expect(find('body')).to have_content 'アイテムトレード購入待ち一覧'
        end

        it '取引が有効状態で表示されている' do
            expect(find('body')).to have_content '詳細'
        end

        include_examples 'アイテムトレードの要素が表示されている'
        include_examples '取引期限が表示されていない'
    end
end

shared_context '売却ユーザ側で、取引が無効状態になっている' do |user_state|
    include_context '売却ユーザがログイン状態になる', user_state

    it 'マイページに遷移している' do
        expect(find('body')).to have_content 'マイページ'
        expect(find('body')).to have_content '反応待ちアイテムトレード一覧'
    end

    include_examples 'アイテムトレードの要素が表示されていない'
    include_examples '取引期限が表示されていない'

    context 'あなたのアイテムトレード一覧に遷移する' do
        before do
            click_link 'あなたのアイテムトレード一覧'
        end

        it 'あなたのアイテムトレード一覧に遷移している' do
            expect(find('body')).to have_content 'あなたのアイテムトレード一覧'
        end

        it '取引が無効状態で有効化リンクが表示されている' do
            expect(find('body')).to have_content '取引を有効化'
        end

        include_examples 'アイテムトレードの要素が表示されている'
        include_examples '取引期限が表示されていない'
    end
end

shared_context '売却ユーザ側で、取引が相手の評価待ち状態になっている' do |user_state|
    include_context '売却ユーザがログイン状態になる', user_state

    it 'マイページに遷移している' do
        expect(find('body')).to have_content 'マイページ'
        expect(find('body')).to have_content '反応待ちアイテムトレード一覧'
    end

    include_examples 'アイテムトレードの要素が表示されていない'
    include_examples '取引期限が表示されていない'

    context 'あなたのアイテムトレード一覧に遷移する' do
        before do
            click_link 'あなたのアイテムトレード一覧'
        end

        it 'あなたのアイテムトレード一覧に遷移している' do
            expect(find('body')).to have_content 'あなたのアイテムトレード一覧'
        end

        it '詳細リンクが表示されている' do
            expect(find('body')).to have_content '詳細'
        end

        include_examples 'アイテムトレードの要素が表示されている'
        include_examples '取引期限が表示されていない'


        context 'あなたのアイテムトレード詳細に遷移する' do
            before do
                click_link '詳細'    
            end
            
            it 'あなたのアイテムトレード詳細に遷移している' do
                expect(find('body')).to have_content 'あなたのアイテムトレード詳細'
            end

            it '取引が相手の評価待ち状態になっている' do
                expect(find('body')).to have_content '現在の取引状態'
                expect(find('body')).to have_content '相手の評価待ち'
            end

            include_examples 'アイテムトレードの要素が表示されている'
            include_examples '取引期限が表示されていない'
        end
    end
end

shared_context '売却ユーザ側で、取引が有効状態になっている' do |user_state|
    include_context '売却ユーザがログイン状態になる', user_state

    it_behaves_like '反応待ちアイテムトレードに取引が表示されている'
end
