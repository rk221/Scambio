require 'rails_helper'

RSpec.describe Game, type: :system do
    let(:admin_user){create(:admin_user)}
    let(:general_user){create(:general_user)}

    describe 'Game' do 
        describe 'when admin user is logging in' do
            let(:login_user){admin_user}
            include_context 'when user is logging in'

            context 'when transitioning game list' do
                before do
                    click_link t_navbar(:admin_games)
                end

                it 'game list is displayed' do
                    main_to_expect.to have_content t('admin.games.index.title')
                end
            end

            describe 'Create' do
                before do
                    click_link t_navbar(:admin_games)
                    click_link t_link_to(:regist)
                end

                it 'create of game is displayed' do 
                    main_to_expect.to have_content t('admin.games.new.title')
                end

                context 'when craete valid game' do 
                    let(:game){build(:game)} 
                    before do 
                        fill_in t_model_attribute_name(Game, :title), with: game.title 
                        click_button t_submit(:create)
                    end

                    it 'a create of game is displayed' do
                        main_to_expect.to have_content t('admin.games.index.title')
                        main_to_expect.to have_content game.title
                    end
                end

                context 'when create invalid game' do 
                    before do 
                        fill_in t_model_attribute_name(Game, :title), with: nil
                        click_button t_submit(:create)
                    end

                    it 'create of game is displayed' do 
                        main_to_expect.to have_content t('admin.games.new.title')
                    end

                    it 'error message is displayed' do
                        main_to_expect.to have_content 'ゲームタイトルを入力してください'
                    end
                end

   
            end 

            describe 'Edit' do 
                let!(:game){create(:game)} 
                before do
                    click_link t_navbar(:admin_games)
                    click_link t_link_to(:edit)
                end

                it 'edit of game is displayed' do 
                    main_to_expect.to have_content t('admin.games.edit.title')
                end

                context 'when update valid game' do 
                    before do 
                        fill_in t_model_attribute_name(Game, :title), with: game.title + '更新版'
                        click_button t_submit(:update)
                    end

                    it 'a update of game is displayed' do
                        main_to_expect.to have_content t('admin.games.index.title')
                        main_to_expect.to have_content game.title + '更新版'
                    end
                end

                context 'when update invalid game' do 
                    before do 
                        fill_in t_model_attribute_name(Game, :title), with: nil
                        click_button t_submit(:update)
                    end

                    it 'edit of game is displayed' do 
                        main_to_expect.to have_content t('admin.games.edit.title')
                    end

                    it 'error message is displayed' do
                        main_to_expect.to have_content 'ゲームタイトルを入力してください'
                    end
                end
            end

            describe 'Destroy' do 
                let!(:game){create(:game)} 
                before do
                    click_link t_navbar(:admin_games)
                    click_link t_link_to(:destroy)
                    accept_confirm
                end

                it 'game is not displayed' do
                    main_to_expect.to have_content t('admin.games.index.title')
                    main_to_expect.to_not have_content game.title
                end
            end
        end
    
        describe 'when general user is logging in' do
            let(:login_user){general_user}
            include_context 'when user is logging in'

            it 'a link to admin games is not displayed' do 
                main_to_expect.to_not have_link t_navbar(:admin_games)
            end
        end
    end
end