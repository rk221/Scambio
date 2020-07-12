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
        admin{false}
    end

    factory :admin_user, class: User do
        firstname {'管理者てすと'}
        lastname {'ゆーざー漢字'}
        nickname {'管理ニックネーム'}
        birthdate {20.year.ago}
        email { 'test2@example.com' }
        password { 'password' }
        password_confirmation { 'password'}
        confirmed_at {Time.zone.now}
        admin{true}
    end

    factory :general_user, class: User do
        firstname {'一般'}
        lastname {'ゆーざー漢字'}
        nickname {'一般ニックネーム'}
        birthdate {20.year.ago}
        email { 'test3@example.com' }
        password { 'password' }
        password_confirmation { 'password'}
        confirmed_at {Time.zone.now}
        admin{false}
    end

    factory :sale_user, class: User do
        firstname {'売却'}
        lastname {'太郎'}
        nickname {'SaleMan'}
        birthdate {20.year.ago}
        email { 'sale@example.com' }
        password { 'password' }
        password_confirmation { 'password'}
        confirmed_at {Time.zone.now}
        admin{false}
    end

    factory :buy_user, class: User do
        firstname {'購入'}
        lastname {'太郎'}
        nickname {'BuyMan'}
        birthdate {20.year.ago}
        email { 'buy@example.com' }
        password { 'password' }
        password_confirmation { 'password'}
        confirmed_at {Time.zone.now}
        admin{false}
    end

    factory :default_login_user, class: User do
        firstname {'標準'}
        lastname {'三郎'}
        nickname {'DefaultMan'}
        birthdate {20.year.ago}
        email { 'default@example.com' }
        password { 'password' }
        password_confirmation { 'password'}
        confirmed_at {Time.zone.now}
        admin{true}
    end
end