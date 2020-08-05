require 'rails_helper'

RSpec.describe ItemGenreGame, type: :system do
    let(:admin_user){create(:admin_user)}
    let(:general_user){create(:general_user)}
    let(:game_data){build(:game)}
    let(:item_genre_data){build(:item_genre)}

    describe 'ItemGenreGame' do 
        let(:login_user){admin_user}
        include_context 'when user is logging in'

        shared_examples 'a item genre game is displayed' do
            before do
                visit admin_games_path
                click_link t('admin.games.index.edit_item_genre_games')
            end

            it 'a item genre game is displayed' do
                main_to_expect.to have_content t('admin.item_genre_games.index.enable_or_disable')
                main_to_expect.to have_content item_genre_data.name
            end
        end

        describe 'Create' do
            context 'when the game is already registered and the item genre is added' do
                before do 
                    game_data.save
                    click_link t_navbar(:item_genres)
                    click_link t_link_to(:regist)
                    fill_in t_model_attribute_name(ItemGenre, :name), with: item_genre_data.name
                    fill_in t_model_attribute_name(ItemGenre, :default_unit_name), with: item_genre_data.default_unit_name
                    click_button t_submit(:create)
                end

                it_behaves_like 'a item genre game is displayed'
            end

            context 'when adding a game when the item genre has been registered' do
                before do 
                    item_genre_data.save
                    click_link t_navbar(:admin_games)
                    click_link t_link_to(:regist)
                    fill_in t_model_attribute_name(Game, :title), with: game_data.title 
                    click_button t_submit(:create)
                end

                it_behaves_like 'a item genre game is displayed'
            end

            describe 'Genre Enable/Disable' do
                let(:item_genre_game_data){build(:item_genre_game)}
                before do
                    item_genre_data.save
                    game_data.save
                    item_genre_game_data.game_id = game_data.id
                    item_genre_game_data.item_genre_id = item_genre_data.id
                    item_genre_game_data.save
                end

                context 'when transitioning edit of item genre game' do 
                    before do
                        visit admin_games_path
                        click_link t('admin.games.index.edit_item_genre_games')
                    end

                    it 'a item genre game is displayed' do
                        main_to_expect.to have_content t('admin.item_genre_games.index.enable_or_disable')
                        main_to_expect.to have_content item_genre_data.name;
                    end

                    it_behaves_like 'a item genre game is displayed'

                    context 'when disable' do
                        before do 
                            click_button t_button_to(:disable)
                        end

                        it 'a link to disable is displayed' do 
                            main_to_expect.to have_button t_button_to(:enable)
                            main_to_expect.to_not have_button t_button_to(:disable)
                        end

                        context 'when enabled' do 
                            before do 
                                click_button t_button_to(:enable)
                            end

                            it 'a link to enable is displayed' do 
                                main_to_expect.to have_button t_button_to(:disable)
                                main_to_expect.to_not have_button t_button_to(:enable)
                            end
                        end
                    end
                end
            end
        end
    end
end