# let login_user
shared_context 'when user is logging in' do
    before do
        visit new_user_session_path
        fill_in t_model_attribute_name(User, 'email'), with: login_user.email
        fill_in t_model_attribute_name(User, 'password'), with: login_user.password
        click_button t('devise.sessions.new.sign_in')
    end
end

shared_context 'when user is logging out' do
    before do 
        click_link t_navbar(:log_out)
    end
end