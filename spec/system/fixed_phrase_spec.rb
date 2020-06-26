require 'rails_helper'
require 'support/user_shared_context'

RSpec.describe FixedPhrase, type: :system do
    let(:general_user){FactoryBot.create(:general_user)}

    describe '定形文CRUD' do 
        let(:login_user){general_user}
        include_context 'ユーザがログイン状態になる'

        describe '定形文表示' do
            it '定形文一覧へのリンクが表示されている' do
                expect(page).to have_link '定形文一覧'
            end

            context '定形文一覧へ遷移している' do
                let!(:fixed_phrase){FactoryBot.create(:fixed_phrase, user_id: login_user.id)}
                before do
                    click_link '定形文一覧'
                end

                it '定形文一覧が表示されている' do
                    expect(page).to have_content '定形文一覧'
                end

                it '定形文が表示されている' do
                    expect(page).to have_content FixedPhrase.human_attribute_name(:name)
                    expect(page).to have_content fixed_phrase.name
                end

                context '定形文詳細へ遷移している' do
                    before do 
                        find('tr[data-href]').click
                    end

                    it '定形文詳細が表示されている' do
                        expect(page).to have_content '定形文詳細'
                    end

                    it '定形文が表示されている' do
                        expect(page).to have_content FixedPhrase.human_attribute_name(:name)
                        expect(page).to have_content fixed_phrase.name
                        expect(page).to have_content FixedPhrase.human_attribute_name(:text)
                        expect(page).to have_content fixed_phrase.text
                    end
                end
            end
        end

        describe '定形文登録' do 
            it '定形文一覧へのリンクが表示されている' do
                expect(page).to have_link '定形文一覧'
            end

            context '定形文登録へ遷移している' do
                let(:fixed_phrase){FactoryBot.build(:fixed_phrase, user_id: login_user.id)}
                before do
                    click_link '定形文一覧'
                    click_link '登録'
                end

                it '定形文登録が表示されている' do
                    expect(page).to have_content '定形文登録'
                end

                context '正しいデータで登録する' do
                    before do
                        fill_in FixedPhrase.human_attribute_name(:name), with: fixed_phrase.name
                        fill_in FixedPhrase.human_attribute_name(:text), with: fixed_phrase.text
                        click_button '登録'
                    end

                    it '定形文詳細が表示されている' do
                        expect(page).to have_content '定形文詳細'
                    end

                    it '定形文が表示されている' do
                        expect(page).to have_content FixedPhrase.human_attribute_name(:name)
                        expect(page).to have_content fixed_phrase.name
                        expect(page).to have_content FixedPhrase.human_attribute_name(:text)
                        expect(page).to have_content fixed_phrase.text
                    end
                end

                context '文字数がオーバーしているデータで登録する' do
                    before do
                        fill_in FixedPhrase.human_attribute_name(:name), with: 'a' * 200
                        fill_in FixedPhrase.human_attribute_name(:text), with: 'a' * 200
                        click_button '登録'
                    end

                    it '定形文詳細が表示されている' do
                        expect(page).to have_content '定形文詳細'
                    end

                    it '定形文が文字数制限最大で、表示されている' do
                        expect(page).to have_content FixedPhrase.human_attribute_name(:name)
                        expect(page).to have_content 'a' * 30
                        expect(page).to have_content FixedPhrase.human_attribute_name(:text)
                        expect(page).to have_content 'a' * 100
                    end
                end
            end
        end

        describe '定形文編集' do 
            let!(:fixed_phrase){FactoryBot.create(:fixed_phrase, user_id: login_user.id)}
            before do
                click_link '定形文一覧'
                find('tr[data-href]').click
            end

            it '定形文詳細が表示されている' do
                expect(page).to have_content '定形文詳細'
            end

            it '定形文が表示されている' do
                expect(page).to have_content FixedPhrase.human_attribute_name(:name)
                expect(page).to have_content fixed_phrase.name
                expect(page).to have_content FixedPhrase.human_attribute_name(:text)
                expect(page).to have_content fixed_phrase.text
            end

            context '定形文編集へ遷移している' do
                before do
                    click_link '編集'
                end

                it '定形文編集が表示されている' do
                    expect(page).to have_content '定形文編集'
                end

                context '定形文を編集する' do
                    before do
                        fill_in FixedPhrase.human_attribute_name(:name), with: fixed_phrase.name + '更新後'
                        fill_in FixedPhrase.human_attribute_name(:text), with: fixed_phrase.text + '更新後'
                        click_button '更新'
                    end

                    it '定形文詳細が表示されている' do
                        expect(page).to have_content '定形文詳細'
                    end

                    it '更新後の定形文が表示されている' do
                        expect(page).to have_content FixedPhrase.human_attribute_name(:name)
                        expect(page).to have_content fixed_phrase.name + '更新後'
                        expect(page).to have_content FixedPhrase.human_attribute_name(:text)
                        expect(page).to have_content fixed_phrase.text + '更新後'
                    end
                end
            end
        end

        describe '定形文削除' do 
            let!(:fixed_phrase){FactoryBot.create(:fixed_phrase, user_id: login_user.id)}
            before do
                click_link '定形文一覧'
                find('tr[data-href]').click
            end

            it '定形文詳細が表示されている' do
                expect(page).to have_content '定形文詳細'
            end

            it '定形文が表示されている' do
                expect(page).to have_content FixedPhrase.human_attribute_name(:name)
                expect(page).to have_content fixed_phrase.name
                expect(page).to have_content FixedPhrase.human_attribute_name(:text)
                expect(page).to have_content fixed_phrase.text
            end

            context '定形文を削除する' do
                before do
                    click_link '削除'
                    accept_confirm
                end
                
                it '定形文一覧が表示されている' do
                    expect(page).to have_content '定形文一覧'
                end

                it '定形文が削除されている' do
                    expect(page).to have_content FixedPhrase.human_attribute_name(:name)
                    expect(page).to_not have_content fixed_phrase.name
                    expect(page).to have_content FixedPhrase.human_attribute_name(:text)
                    expect(page).to_not have_content fixed_phrase.text
                end
            end
        end
    end
end