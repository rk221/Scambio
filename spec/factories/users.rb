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

    factory :admin_user, class: User do
        firstname {'管理者てすと'}
        lastname {'ゆーざー漢字'}
        nickname {'ニックネーム'}
        birthdate {20.year.ago}
        email { 'test2@example.com' }
        password { 'password' }
        password_confirmation { 'password'}
        confirmed_at {Time.zone.now}
        admin_flag{true}
    end

    factory :general_user, class: User do
        firstname {'一般'}
        lastname {'ゆーざー漢字'}
        nickname {'ニックネーム'}
        birthdate {20.year.ago}
        email { 'test3@example.com' }
        password { 'password' }
        password_confirmation { 'password'}
        confirmed_at {Time.zone.now}
        admin_flag{false}
    end
end