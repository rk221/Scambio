CSV.foreach('db/seeds/development/csv/users.csv', headers: true) do |row|
    user = User.new(
        firstname: row['firstname'],
        lastname: row['lastname'],
        nickname: row['nickname'],
        admin: row['admin'],
        birthdate: Date.parse(row['birthdate']),
        email: row['email'],
        password: row['password'],
        password_confirmation: row['password'],
        confirmed_at: Time.zone.now
    )

    if user.save
        play_station = PlayStationNetworkId.new(user_id: user.id, psn_id: row['psn_id'])
        unless play_station.save
            p "play_station_save_error: #{play_station.errors}"
        end

        nintendo = NintendoFriendCode.new(user_id: user.id, friend_code: row['friend_code'])
        unless nintendo.save
            p "nintendo_save_error: #{nintendo.errors}"
        end
    else
        p "user_save_error: #{user.errors}"
    end
end