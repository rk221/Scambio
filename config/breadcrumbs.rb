crumb :root do
  link "Home", root_path
end

crumb :user do 
  link t('users.show.title'), user_path(current_user)
end

crumb :edit_user_registration do
  link t('users.registrations.edit.edit'), edit_user_registration_path
  parent :user
end

crumb :user_message_posts do
  link t('users.message_posts.index.title'), user_message_posts_path(current_user)
  parent :user
end

crumb :user_message_post do |user_message_post_id|
  link t('users.message_posts.show.title'), user_message_post_path(id: user_message_post_id, user_id: current_user.id)
  parent :user_message_posts
end

crumb :user_item_trades do
  link t('users.item_trades.index.title'), user_item_trades_path(current_user)
  parent :user
end

crumb :user_item_trade do |item_trade_id|
  link t('users.item_trades.show.title'), user_item_trade_path(id: item_trade_id, user_id: current_user.id)
  parent :user_item_trades
end

crumb :user_item_trade_queues do
  link t('users.item_trade_queues.index.title'), user_item_trade_queues_path(current_user)
  parent :user
end

crumb :user_item_trade_queue do |item_trade_queue_id|
  link t('users.item_trade_queues.show.title'), user_item_trade_queue_path(id: item_trade_queue_id, user_id: current_user.id)
  parent :user_item_trade_queues
end

crumb :user_edit_buy_item_trade_detail do |item_trade_detail|
  link t('users.item_trade_details.edit_buy.title'), user_edit_buy_item_trade_detail_path(id: item_trade_detail.id, user_id: current_user.id)
  parent :user_item_trade, item_trade_detail.item_trade_queue.item_trade.id
end

crumb :user_edit_sale_item_trade_detail do |item_trade_detail|
  link t('users.item_trade_details.edit_sale.title'), user_edit_sale_item_trade_detail_path(id: item_trade_detail.id, user_id: current_user.id)
  parent :user_item_trade_queue, item_trade_detail.item_trade_queue.id 
end

crumb :admin_games do 
  link t('admin.games.index.title'), admin_games_path
end

crumb :new_admin_game do 
  link t('admin.games.new.title'), new_admin_game_path
  parent :admin_games
end

crumb :edit_admin_game do |game_id|
  link t('admin.games.edit.title'), edit_admin_game_path(game_id: game_id)
  parent :admin_games
end

crumb :admin_badges do 
  link t('admin.badges.index.title'), admin_badges_path
end

crumb :admin_badge do |badge_id|
  link t('admin.badges.index.title'), admin_badge_path(id: badge_id)
  parent :admin_badges
end

crumb :new_admin_badge do 
  link t('admin.badges.new.title'), new_admin_badge_path
  parent :admin_badges
end

crumb :edit_admin_badge do |badge_id|
  link t('admin.badges.edit.title'), edit_admin_badge_path(id: badge_id)
  parent :admin_badges
end

crumb :admin_item_genres do 
  link t('admin.item_genres.index.title'), admin_item_genres_path
end

crumb :new_admin_item_genre do 
  link t('admin.item_genres.new.title'), new_admin_item_genre_path
  parent :admin_item_genres
end

crumb :edit_admin_item_genre do |item_genre_id|
  link t('admin.item_genres.edit.title'), edit_admin_item_genre_path(id: item_genre_id)
  parent :admin_item_genres
end

crumb :admin_item_genre_games do |game_id|
  link t('admin.item_genre_games.index.title'), admin_item_genre_games_path(id: game_id)
  parent :admin_games
end

crumb :user_codes do 
  link t('users.codes.index.title'), user_codes_path(current_user)
  parent :user
end

crumb :new_user_nintendo_friend_code do
  link t('users.codes.nintendo_friend_codes.new.title'), new_user_codes_nintendo_friend_code_path(current_user)
  parent :user_codes
end

crumb :edit_user_nintendo_friend_code do |nintendo_friend_code_id|
  link t('users.codes.nintendo_friend_codes.edit.title'), edit_user_codes_nintendo_friend_code_path(id: nintendo_friend_code_id, user_id: current_user.id)
  parent :user_codes
end

crumb :new_user_play_station_network_id do
  link t('users.codes.play_station_network_ids.new.title'), new_user_codes_play_station_network_id_path(current_user)
  parent :user_codes
end

crumb :edit_user_play_station_network_id do |play_station_network_id_id| 
  link t('users.codes.play_station_network_ids.edit.title'), edit_user_codes_play_station_network_id_path(id: play_station_network_id_id, user_id: current_user.id)
  parent :user_codes
end

crumb :user_fixed_phrases do
  link t('users.fixed_phrases.index.title'), user_fixed_phrases_path(current_user)
  parent :user
end

crumb :user_fixed_phrase do |fixed_phrase_id|
  link t('users.fixed_phrases.show.title'), user_fixed_phrase_path(id: fixed_phrase_id, user_id: current_user.id)
  parent :user_fixed_phrases
end

crumb :new_user_fixed_phrase do
  link t('users.fixed_phrases.show.title'), new_user_fixed_phrase_path(current_user)
  parent :user_fixed_phrases
end

crumb :edit_user_fixed_phrase do |fixed_phrase_id|
  link t('users.fixed_phrases.show.title'), edit_user_fixed_phrase_path(id: fixed_phrase_id, user_id: current_user.id)
  parent :user_fixed_phrase, fixed_phrase_id
end

crumb :user_badges do
  link t('users.badges.index.title'), user_badges_path(current_user)
  parent :user
end

crumb :edit_user_badges do
  link t('users.badges.edit.title'), edit_user_badges_path(current_user) 
  parent :user_badges
end

crumb :games do
  link t('games.index.title'), games_path
end

crumb :game_item_trades do |game_id|
  link t('games.item_trades.index.title'), game_item_trades_path(game_id: game_id)
  parent :games
end

crumb :new_game_item_trade do |game_id|
  link t('games.item_trades.new.title'), new_game_item_trade_path(game_id: game_id)
  parent :game_item_trades, game_id
end

crumb :edit_game_item_trade do |item_trade|
  link t('games.item_trades.edit.title'), edit_game_item_trade_path(id: item_trade.id, game_id: item_trade.game_id)
  parent :user_item_trade, item_trade.id
end

# crumb :projects do
#   link "Projects", projects_path
# end

# crumb :project do |project|
#   link project.name, project_path(project)
#   parent :projects
# end

# crumb :project_issues do |project|
#   link "Issues", project_issues_path(project)
#   parent :project, project
# end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).