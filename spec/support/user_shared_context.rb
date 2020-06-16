# ログインユーザを予めletで定義する必要あり
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