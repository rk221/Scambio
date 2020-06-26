crumb :root do
  link "Home", root_path
end

crumb :mypage do 
  link t('users.show.title'), user_path(current_user)
end

crumb :edit_user do
  link t('users.registrations.edit.edit'), edit_user_registration_path
  parent :mypage
end

crumb :user_message_posts do
  link t('users.user_message_posts.index.title'), user_user_message_posts_path(current_user)
  parent :mypage
end

crumb :user_message_post do |user_message_post_id|
  link t('users.user_message_posts.show.title'), user_user_message_post_path(id: user_message_post_id, user_id: current_user.id)
  parent :mypage
end

crumb :user_item_trades do
  link t('users.user_item_trades.index.title'), user_user_item_trades_path(current_user)
  parent :mypage
end

crumb :user_item_trade do |item_trade_id|
  link t('users.user_item_trades.show.title'), user_user_item_trade_path(id: item_trade_id, user_id: current_user.id)
  parent :user_item_trades
end

crumb :user_item_trade_queues do
  link t('users.item_trade_queues.index.title'), user_item_trade_queues_path(current_user)
  parent :mypage
end

crumb :user_item_trade_queue do |item_trade_queue_id|
  link t('users.item_trade_queues.show.title'), user_item_trade_queue_path(id: item_trade_queue_id, user_id: current_user.id)
  parent :user_item_trade_queues
end

crumb :edit_buy_item_trade_detail do |item_trade_detail_id|
  link t('item_trade_details.edit_buy.title'), edit_buy_item_trade_detail_path(id: item_trade_detail_id)
end

crumb :edit_sale_item_trade_detail do |item_trade_detail_id|
  link t('item_trade_details.edit_sale.title'), edit_sale_item_trade_detail_path(id: item_trade_detail_id)
end

crumb :admin_games do 
  link t('admin.games.index.title'), admin_games_path
end

crumb :admin_new_game do 
  link t('admin.games.new.title'), new_admin_game_path
  parent :admin_games
end

crumb :admin_edit_game do |game_id|
  link t('admin.games.edit.title'), edit_admin_game_path(game_id: game_id)
  parent :admin_games
end

crumb :item_genres do 
  link t('admin.item_genres.index.title'), admin_item_genres_path
end

crumb :new_item_genre do 
  link t('admin.item_genres.new.title'), new_admin_item_genre_path
  parent :item_genres
end

crumb :edit_item_genre do |item_genre_id|
  link t('admin.item_genres.edit.title'), edit_admin_item_genre_path(id: item_genre_id)
  parent :item_genres
end

crumb :item_genre_games do |game_id|
  link t('admin.item_genre_games.index.title'), admin_item_genres_path(id: game_id)
  parent :games
end

crumb :codes do 
  link t('codes.index.title'), codes_path
end

crumb :new_nintendo_friend_code do
  link t('codes.nintendo_friend_codes.new.title'), new_codes_nintendo_friend_code_path
  parent :codes
end

crumb :edit_nintendo_friend_code do |nintendo_friend_code_id|
  link t('codes.nintendo_friend_codes.edit.title'), edit_codes_nintendo_friend_code_path(id: nintendo_friend_code_id)
  parent :codes
end

crumb :new_play_station_network_id do
  link t('codes.play_station_network_ids.new.title'), new_codes_play_station_network_id_path
  parent :codes
end

crumb :edit_play_station_network_id do |play_station_network_id_id| 
  link t('codes.play_station_network_ids.edit.title'), edit_codes_play_station_network_id_path(id: play_station_network_id_id)
  parent :codes
end

crumb :fixed_phrases do
  link t('fixed_phrases.index.title'), fixed_phrases_path
  parent :mypage
end

crumb :fixed_phrase do |fixed_phrase_id|
  link t('fixed_phrases.show.title'), fixed_phrase_path(fixed_phrase_id)
  parent :fixed_phrases
end

crumb :new_fixed_phrase do
  link t('fixed_phrases.show.title'), new_fixed_phrase_path
  parent :fixed_phrases
end

crumb :edit_fixed_phrase do |fixed_phrase_id|
  link t('fixed_phrases.show.title'), edit_fixed_phrase_path(fixed_phrase_id)
  parent :fixed_phrase, fixed_phrase_id
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
  parent :game_item_trades, item_trade.game_id
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