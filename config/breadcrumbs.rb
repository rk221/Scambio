crumb :root do
  link "Home", root_path
end

crumb :profile do 
  link "プロフィール", users_show_path
end

crumb :edit_profile do
  link "プロフィール変更", edit_user_registration_path
  parent :profile
end

crumb :games do 
  link "ゲーム一覧", admin_games_path
end

crumb :new_game do 
  link "ゲーム登録", new_admin_game_path
  parent :games
end

crumb :edit_game do 
  link "ゲーム編集", edit_admin_game_path
  parent :games
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