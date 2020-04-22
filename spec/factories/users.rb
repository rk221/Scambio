FactoryBot.define do
    factory :user do
        firstname {'てすと'}
        lastname {'ゆーざー漢字'}
        nickname {'ニックネーム'}
        email { 'test1@example.com' }
        password { 'password' }
        password_confirmation { 'password'}
    end
end