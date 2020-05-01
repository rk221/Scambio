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

crumb :games do 
  link t('admin.games.index.title'), admin_games_path
end

crumb :new_game do 
  link t('admin.games.new.title'), new_admin_game_path
  parent :games
end

crumb :edit_game do 
  link t('admin.games.edit.title'), edit_admin_game_path
  parent :games
end

crumb :codes do 
  link t('codes.index.title'), codes_path
end

crumb :new_nintendo_friend_code do 
  link t('codes.nintendo_friend_codes.new.title'), new_codes_nintendo_friend_code_path
  parent :codes
end

crumb :edit_nintendo_friend_code do 
  link t('codes.nintendo_friend_codes.edit.title'), edit_codes_nintendo_friend_code_path
  parent :codes
end

crumb :new_play_station_network_id do 
  link t('codes.play_station_network_ids.new.title'), new_codes_play_station_network_id_path
  parent :codes
end

crumb :edit_play_station_network_id do 
  link t('codes.play_station_network_ids.edit.title'), edit_codes_play_station_network_id_path
  parent :codes
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