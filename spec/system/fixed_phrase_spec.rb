require 'rails_helper'

RSpec.describe FixedPhrase, type: :system do
    let(:general_user){create(:general_user)}

    describe 'FixPhrase' do 
        let(:login_user){general_user}
        include_context 'when user is logging in'

        describe 'Index' do
            it 'a link to fixed phrase list is displayed' do
                main_to_expect.to have_link t('users.show.fixed_phrases') 
            end

            context 'when transitioning to fixed phrase list' do
                let!(:fixed_phrase){create(:fixed_phrase, user: login_user)}
                before do
                    click_link t('users.show.fixed_phrases')
                end

                it 'a fixed phrase list is displayed' do
                    main_to_expect.to have_content t('fixed_phrases.index.title')
                    main_to_expect.to have_content FixedPhrase.human_attribute_name(:name)
                    main_to_expect.to have_content fixed_phrase.name
                end

                context 'when transitioning to detail of fixed phrase' do
                    before do 
                        find('tr[data-href]').click
                    end

                    it 'detail of fixed phrase is displayed' do
                        main_to_expect.to have_content t('fixed_phrases.show.title')
                        main_to_expect.to have_content FixedPhrase.human_attribute_name(:name)
                        main_to_expect.to have_content fixed_phrase.name
                        main_to_expect.to have_content FixedPhrase.human_attribute_name(:text)
                        main_to_expect.to have_content fixed_phrase.text
                    end
                end
            end
        end

        describe 'Create' do 
            it 'a link to fixed phrase list is displayed' do
                main_to_expect.to have_link t('users.show.fixed_phrases') 
            end

            context 'when transitioning to creat of fixed phrase' do
                let(:fixed_phrase){build(:fixed_phrase, user: login_user)}
                before do
                    click_link t('users.show.fixed_phrases')
                    click_link t_link_to(:regist)
                end

                it 'create of fixed phrase is displayed' do
                    main_to_expect.to have_content t('fixed_phrases.new.title')
                end

                context 'when create valid item genre' do
                    before do
                        fill_in FixedPhrase.human_attribute_name(:name), with: fixed_phrase.name
                        fill_in FixedPhrase.human_attribute_name(:text), with: fixed_phrase.text
                        click_button t_submit(:create)
                    end

                    it 'detail of fixed phrase is displayed' do
                        main_to_expect.to have_content t('fixed_phrases.show.title')
                        main_to_expect.to have_content FixedPhrase.human_attribute_name(:name)
                        main_to_expect.to have_content fixed_phrase.name
                        main_to_expect.to have_content FixedPhrase.human_attribute_name(:text)
                        main_to_expect.to have_content fixed_phrase.text
                    end
                end

                context 'when create invalid item genre' do
                    before do
                        fill_in FixedPhrase.human_attribute_name(:name), with: ""
                        fill_in FixedPhrase.human_attribute_name(:text), with: ""
                        click_button t_submit(:create)
                    end

                    it 'create of fixed phrase is displayed' do
                        main_to_expect.to have_content t('fixed_phrases.new.title')
                    end
                end
            end
        end

        describe 'Edit' do 
            let!(:fixed_phrase){create(:fixed_phrase, user: login_user)}
            before do
                click_link t('users.show.fixed_phrases')
                find('tr[data-href]').click
            end

            it 'detail of fixed phrase is displayed' do
                main_to_expect.to have_content t('fixed_phrases.show.title')
                main_to_expect.to have_content FixedPhrase.human_attribute_name(:name)
                main_to_expect.to have_content fixed_phrase.name
                main_to_expect.to have_content FixedPhrase.human_attribute_name(:text)
                main_to_expect.to have_content fixed_phrase.text
            end

            context 'when transitioning to edit of fixed phrase' do
                before do
                    click_link t_link_to(:edit)
                end

                it 'edit of fixed phrase is displayed' do
                    main_to_expect.to have_content t('fixed_phrases.edit.title')
                end

                context 'when edit valid item genre' do
                    before do
                        fill_in FixedPhrase.human_attribute_name(:name), with: fixed_phrase.name + '更新後'
                        fill_in FixedPhrase.human_attribute_name(:text), with: fixed_phrase.text + '更新後'
                        click_button t_submit(:update)
                    end

                    it 'detail of fixed phrase is displayed' do
                        main_to_expect.to have_content t('fixed_phrases.show.title')
                        main_to_expect.to have_content FixedPhrase.human_attribute_name(:name)
                        main_to_expect.to have_content fixed_phrase.name + '更新後'
                        main_to_expect.to have_content FixedPhrase.human_attribute_name(:text)
                        main_to_expect.to have_content fixed_phrase.text + '更新後'
                    end
                end
            end
        end

        describe 'Destroy' do 
            let!(:fixed_phrase){create(:fixed_phrase, user: login_user)}
            before do
                click_link t('users.show.fixed_phrases')
                find('tr[data-href]').click
            end

            it 'detail of fixed phrase is displayed' do
                main_to_expect.to have_content t('fixed_phrases.show.title')
                main_to_expect.to have_content FixedPhrase.human_attribute_name(:name)
                main_to_expect.to have_content fixed_phrase.name
                main_to_expect.to have_content FixedPhrase.human_attribute_name(:text)
                main_to_expect.to have_content fixed_phrase.text
            end

            context 'when destroy fixed phrase' do
                before do
                    click_link t_link_to(:destroy)
                    accept_confirm
                end

                it 'fixed phrase is not displayed' do
                    main_to_expect.to have_content t('fixed_phrases.index.title')
                    main_to_expect.to_not have_content fixed_phrase.name
                end
            end
        end
    end
end