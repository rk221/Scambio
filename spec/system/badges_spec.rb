require 'rails_helper'

RSpec.describe Badge, type: :system do
    let!(:admin_user){create(:admin_user)}
    let!(:general_user){create(:general_user)}

    let!(:game){create(:game)}

    describe 'Badge' do 
        describe 'when admin user is logging in' do
            let(:login_user){admin_user}
            include_context 'when user is logging in'

            context 'when transitioning badge list' do
                let!(:badge){create(:badge, game: game, item_trade_count_condition: 1, rank_condition: 0)}
                before do
                    click_link t_navbar(:admin_badges)
                end

                it 'badge list is displayed' do
                    main_to_expect.to have_content t('admin.badges.index.title')
                    main_to_expect.to have_content badge.name
                end
            end

            describe 'Create' do
                let!(:badge){build(:badge, game: game, item_trade_count_condition: 1, rank_condition: 0)}
                before do
                    click_link t_navbar(:admin_badges)
                    click_link t_link_to(:regist)
                end

                it 'create of badge is displayed' do 
                    main_to_expect.to have_content t('admin.badges.new.title')
                end

                context 'when craete valid badge' do 
                    before do 
                        fill_in t_model_attribute_name(Badge, :name), with: badge.name
                        fill_in t_model_attribute_name(Badge, :item_trade_count_condition), with: badge.item_trade_count_condition
                        fill_in t_model_attribute_name(Badge, :rank_condition), with: badge.rank_condition
                        click_button t_submit(:create)
                    end

                    it 'a create of badge is displayed' do
                        main_to_expect.to have_content t('admin.badges.index.title')
                        main_to_expect.to have_content game.title
                        main_to_expect.to have_content badge.name
                    end
                end

                context 'when create invalid game' do 
                    before do 
                        fill_in t_model_attribute_name(Badge, :name), with: nil
                        fill_in t_model_attribute_name(Badge, :item_trade_count_condition), with: badge.item_trade_count_condition
                        fill_in t_model_attribute_name(Badge, :rank_condition), with: badge.rank_condition
                        click_button t_submit(:create)
                    end

                    it 'create of badge is displayed' do 
                        main_to_expect.to have_content t('admin.badges.new.title')
                    end
                end
            end 

            describe 'Edit' do 
                let!(:badge){create(:badge, game: game, item_trade_count_condition: 1, rank_condition: 0)}
                before do
                    click_link t_navbar(:admin_badges)
                    click_link t_link_to(:edit)
                end

                it 'edit of badge is displayed' do 
                    main_to_expect.to have_content t('admin.badges.edit.title')
                end

                context 'when update valid badge' do 
                    before do 
                        fill_in t_model_attribute_name(Badge, :name), with: badge.name + "更新版"
                        fill_in t_model_attribute_name(Badge, :item_trade_count_condition), with: badge.item_trade_count_condition
                        fill_in t_model_attribute_name(Badge, :rank_condition), with: badge.rank_condition
                        click_button t_submit(:update)
                    end

                    it 'a update of badge is displayed' do
                        main_to_expect.to have_content t('admin.badges.show.title')
                        main_to_expect.to have_content badge.name + '更新版'
                    end
                end

                context 'when update invalid game' do 
                    before do 
                        fill_in t_model_attribute_name(Badge, :name), with: nil
                        fill_in t_model_attribute_name(Badge, :item_trade_count_condition), with: badge.item_trade_count_condition
                        fill_in t_model_attribute_name(Badge, :rank_condition), with: badge.rank_condition
                        click_button t_submit(:update)
                    end

                    it 'edit of badge is displayed' do 
                        main_to_expect.to have_content t('admin.badges.edit.title')
                    end
                end
            end

            describe 'Destroy' do 
                let!(:badge){create(:badge, game: game, item_trade_count_condition: 1, rank_condition: 0)}
                let!(:user_badge){create(:user_badge, user: login_user, badge: badge, wear: true)}

                before do
                    click_link t_navbar(:admin_badges)
                    click_link t_link_to(:destroy)
                    accept_confirm
                end

                it 'badge is not displayed' do
                    main_to_expect.to have_content t('admin.badges.index.title')
                    main_to_expect.to_not have_content badge.name
                end

                context 'when trantitioning user badges' do 
                    before do
                        click_link t_navbar(:mypage)
                        click_link t('users.show.badges')
                    end

                    it 'user_badge is not displayed' do
                        main_to_expect.to have_content t('users.badges.index.title')
                        main_to_expect.to_not have_content badge.name
                    end
                end
            end
        end
    
        describe 'when general user is logging in' do
            let(:login_user){general_user}
            include_context 'when user is logging in'

            it 'a link to admin games is not displayed' do 
                main_to_expect.to_not have_link t_navbar(:admin_badges)
            end
        end
    end
end