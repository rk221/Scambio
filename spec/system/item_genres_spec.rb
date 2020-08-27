require 'rails_helper'

RSpec.describe ItemGenre, type: :system do
    let(:admin_user){create(:admin_user)}
    let(:general_user){create(:general_user)}

    describe 'Item Genre' do 
        describe 'when admin user is logging in' do
            let(:login_user){admin_user}
            include_context 'when user is logging in'

            context 'when transitioning item genre list' do
                before do
                    click_link t_navbar(:admin_item_genres)
                end

                it 'item genre list is displayed' do
                    main_to_expect.to have_content t('admin.item_genres.index.title')
                end
            end

            describe 'Create' do
                before do
                    click_link t_navbar(:admin_item_genres)
                    click_link t_link_to(:regist)
                end

                it 'create of item genre is displayed' do 
                    main_to_expect.to have_content t('admin.item_genres.new.title') 
                end

                context 'when create valid item genre' do 
                    let(:item_genre){build(:item_genre)} 
                    before do 
                        fill_in t_model_attribute_name(ItemGenre, :name), with: item_genre.name 
                        fill_in t_model_attribute_name(ItemGenre, :default_unit_name), with: item_genre.default_unit_name 
                        click_button t_submit(:create)
                    end

                    it 'a create of item genre is displayed' do
                        main_to_expect.to have_content t('admin.item_genres.index.title')
                        main_to_expect.to have_content item_genre.name
                        main_to_expect.to have_content item_genre.default_unit_name
                    end
                end

                context 'when create invalid item genre' do 
                    before do 
                        fill_in t_model_attribute_name(ItemGenre, :name), with: nil
                        click_button t_submit(:create)
                    end

                    it 'create of item genre is displayed' do 
                        main_to_expect.to have_content t('admin.item_genres.new.title') 
                    end

                    it 'error message is displayed' do
                        main_to_expect.to have_content 'アイテムジャンル名を入力してください'
                    end
                end
            end 

            describe 'Edit' do 
                let!(:item_genre){create(:item_genre)} 
                before do
                    click_link t_navbar(:admin_item_genres)
                    click_link t_link_to(:edit)
                end


                it 'edit of item genre is displayed' do 
                    main_to_expect.to have_content t('admin.item_genres.edit.title') 
                end

                context 'when update valid item genre' do 
                    before do 
                        fill_in t_model_attribute_name(ItemGenre, :name), with: item_genre.name + "更新版"
                        fill_in t_model_attribute_name(ItemGenre, :default_unit_name), with: item_genre.default_unit_name + "更新版"
                        click_button t_submit(:update)
                    end

                    it 'a update of item genre is displayed' do
                        main_to_expect.to have_content t('admin.item_genres.index.title')
                        main_to_expect.to have_content item_genre.name + "更新版"
                        main_to_expect.to have_content item_genre.default_unit_name + "更新版"
                    end
                end

                context 'when update invalid item genre' do 
                    before do 
                        fill_in t_model_attribute_name(ItemGenre, :default_unit_name), with: ""
                        click_button t_submit(:update)
                    end

                    it 'edit of item genre is displayed' do 
                        main_to_expect.to have_content t('admin.item_genres.edit.title') 
                    end

                    it 'error message is displayed' do
                        main_to_expect.to have_content 'デフォルトの単位名を入力してください'
                    end
                end
            end 

            describe 'Destroy' do 
                let!(:item_genre){create(:item_genre)} 

                before do
                    click_link t_navbar(:admin_item_genres)
                    click_link t_link_to(:destroy)
                    accept_confirm
                end

                it 'item genre is not displayed' do 
                    main_to_expect.to have_content t('admin.item_genres.index.title')
                    main_to_expect.to_not have_content item_genre.name
                end
            end
        end
    
        describe 'when general user is logging in' do
            let(:login_user){general_user}
            include_context 'when user is logging in'

            it 'a link to item genre is not displayed' do 
                main_to_expect.to_not have_link t_navbar(:admin_item_genres)
            end
        end
    end
end