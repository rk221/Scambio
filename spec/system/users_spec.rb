require 'rails_helper'

RSpec.describe User, type: :system do
    let(:general_user){create(:general_user)}
    let!(:game){create(:game)}
    let!(:item_genre){create(:item_genre)}
    let!(:item_genre_game){create(:item_genre_game, item_genre: item_genre, game: game, enable: true)}
    let!(:buy_item){create(:buy_item, item_genre: item_genre, game: game)}
    let!(:sale_item){create(:sale_item, item_genre: item_genre, game: game)}
     

    describe 'MyPage' do
        let(:login_user){general_user}
        include_context 'when user is logging in'

        it 'a login flash message is displayed' do
            expect(find('#flash')).to have_content 'ログインしました'
        end

        context 'when transitioning to mypage' do
            before do
                click_link t_navbar(:mypage)
            end

            it 'a link to edit user is displayed' do
                main_to_expect.to have_link t('users.show.edit_user')
            end

            it 'a link to codes is displayed' do
                main_to_expect.to have_link t('users.show.codes')
            end

            it "a link to user's item trades is displayed" do
                main_to_expect.to have_link t('users.show.user_item_trades')
            end

            context "with there is user's game ranks" do
                let!(:user_game_rank){create(:user_game_rank, user: login_user, game: game)}
                before do
                    visit current_path
                end

                it "user's game ranks is displayed" do
                    main_to_expect.to have_content t('users.show.recent_user_game_rank')
                    main_to_expect.to have_content t_model_attribute_name(Game, :title)
                    main_to_expect.to have_content game.title
                    main_to_expect.to have_content t_model_attribute_name(UserGameRank, :rank)
                    main_to_expect.to have_content t_model_attribute_name(UserGameRank, :gray)
                end
            end
        end
    end
end
