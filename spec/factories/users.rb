FactoryBot.define do
    factory :user do
        firstname {'てすと'}
        lastname {'ゆーざー漢字'}
        nickname {'ニックネーム'}
        birthdate {20.year.ago}
        email { 'test1@example.com' }
        password { 'password' }
        password_confirmation { 'password'}
        confirmed_at {Time.zone.now}
        admin_flag{false}
    end
end