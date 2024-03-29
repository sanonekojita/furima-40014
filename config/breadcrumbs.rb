crumb :root do
  link "Home", root_path
end

crumb :users_show do
  link "ユーザー情報", user_path(current_user)
  parent :root
end

crumb :users_edit do
  link "ユーザー情報更新", edit_user_path
  parent :users_show
end

crumb :cards_new do
  link "カード情報登録", new_card_path
  parent :users_show
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
