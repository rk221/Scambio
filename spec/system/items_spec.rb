require 'rails_helper'

RSpec.describe Item, type: :system do
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

    let!(:item_trade){create(:item_trade, user: sale_user, game: game, buy_item: buy_item, sale_item: sale_item, user_game_rank: sale_user_game_rank)}

    describe 'Item' do 
        describe 'when admin user is logging in' do
            let(:login_user){admin_user}
            include_context 'when user is logging in'

            describe 'Index' do
                context 'when transitioning item list' do
                    before do
                        click_link t_navbar(:admin_items)
                    end

                    it 'item list is displayed' do
                        main_to_expect.to have_content t('admin.items.index.title')
                        main_to_expect.to have_content t_model_attribute_name(Game, :title)
                        main_to_expect.to have_content game.title
                        main_to_expect.to have_content t_model_attribute_name(ItemGenre, :name)
                        main_to_expect.to have_content item_genre.name
                        main_to_expect.to have_content t_model_attribute_name(Item, :name)
                        main_to_expect.to have_content buy_item.name
                        main_to_expect.to have_content sale_item.name
                        main_to_expect.to have_content t_model_attribute_name(Item, :unit_name)
                        main_to_expect.to have_content t_link_to(:show)
                        main_to_expect.to have_content t_link_to(:edit)
                    end
                end
            end

            describe 'Show' do
                context 'when transitioning item show' do
                    before do
                        click_link t_navbar(:admin_items)
                        within "#item_id_#{sale_item.id}" do
                            click_link t_link_to(:show)
                        end
                    end

                    it 'sale item is displayed' do
                        expect(page).to have_content t('admin.items.show.title')
                        within "#item" do
                            expect(page).to have_content t_model_attribute_name(Game, :title)
                            expect(page).to have_content game.title
                            expect(page).to have_content t_model_attribute_name(ItemGenre, :name)
                            expect(page).to have_content sale_item.item_genre.name
                            expect(page).to have_content t_model_attribute_name(Item, :name)
                            expect(page).to have_content sale_item.name
                            expect(page).to have_content t_model_attribute_name(Item, :unit_name)
                            expect(page).to have_content t_model_attribute_name(Item, :registered_count_sale_item_trades)
                            expect(page).to have_content t_model_attribute_name(Item, :registered_count_buy_item_trades)
                        end
                    end
                end
            end

            describe 'Edit' do 
                context 'when transitioning item edit' do
                    before do
                        click_link t_navbar(:admin_items)
                        within "#item_id_#{sale_item.id}" do
                            click_link t_link_to(:show)
                        end
                        click_link t_link_to(:edit)
                    end

                    it 'sale item is displayed' do
                        expect(page).to have_content t('admin.items.edit.title')
                        within "#item" do
                            expect(page).to have_content t_model_attribute_name(Game, :title)
                            expect(page).to have_content game.title
                            expect(page).to have_content t_model_attribute_name(ItemGenre, :name)
                            expect(page).to have_content sale_item.item_genre.name
                            expect(page).to have_content t_model_attribute_name(Item, :name)
                            expect(page).to have_content sale_item.name
                            expect(page).to have_content t_model_attribute_name(Item, :unit_name)
                        end
                    end

                    context 'when update valid item' do 
                        before do 
                            fill_in t_model_attribute_name(Item, :unit_name), with: "テスト単位名"
                            click_button t_submit(:update)
                        end

                        it 'a update of item unit name is displayed' do
                            main_to_expect.to have_content t('admin.items.show.title')
                            main_to_expect.to have_content t_model_attribute_name(Item, :unit_name)
                            main_to_expect.to have_content 'テスト単位名'
                        end
                    end
                end
            end
        end

        describe 'when general user is logging in' do
            let(:login_user){general_user}
            include_context 'when user is logging in'

            it 'a link to admin items is not displayed' do 
                main_to_expect.to_not have_link t_navbar(:admin_items)
            end
        end
    end
end