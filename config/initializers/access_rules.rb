# Localization.lang = ''
# LisiaSoft::AccessControl, permit to manage, backend, and frontend access.
# Based on the LoginSystem of Lipisadmin
# You can define on the fly, roles access, for example:
#
#   Typo::AccessControl.map :require => [ :administrator, :manager, :customer ]  do |map|
#     # Shared Permission
#     map.permission "backend/base"
#     # Module Permission
#     map.project_module :accounts, "backend/accounts" do |project|
#       project.menu :list, { :action => :index }, :class => "icon-no-group"
#       project.menu :new,  { :action => :new }, :class => "icon-new"
#     end
#
#   end
#
#   Typo::AccessControl.map :require => :customer do |map|
#     # Shared Permission
#     map.permission "frontend/cart"
#     # Module Permission
#     map.project_module :store, "frontend/store" do |map|
#       map.menu :add, { :cart => :add }, :class => "icon-no-group"
#       map.menu :list,  { :cart => :list }, :class => "icon-no-group"
#     end
#   end
#
# So the when you do:
#
#   Typo::AccessControl.roles
#   # => [:administrator, :manager, :customer]
#
#   Typo::AccessControl.project_modules(:customer)
#   # => [#<Typo::AccessControl::ProjectModule:0x254a9c8 @controller="backend/accounts", @name=:accounts, @menus=[#<Typo::AccessControl::Menu:0x254a928 @url={:action=>:index}, @name=:list, @options={:class=>"icon-no-group"}>, #<Typo::AccessControl::Menu:0x254a8d8 @url={:action=>:new}, @name=:new, @options={:class=>"icon-new"}>]>, #<Typo::AccessControl::ProjectModule:0x254a84c @controller="frontend/store", @name=:store, @menus=[#<Typo::AccessControl::Menu:0x254a7d4 @url={:cart=>:add}, @name=:add, @options={}>, #<Typo::AccessControl::Menu:0x254a798 @url={:cart=>:list}, @name=:list, @options={}>]>]
#
#   Typo::AccessControl.allowed_controllers(:customer)
#   => ["backend/base", "backend/accounts", "frontend/cart", "frontend/store"]
#
# If in your controller there is *login_required* our Authenticated System verify the allowed_controllers for the account role (Ex: :customer),
# if not satisfed you will be redirected to login page.
#
# An account have two columns, role, that is a string, and project_modules, that is an array (with serialize)
#
# For example, whe can decide that an Account with role :customers can see only, the module project :store.

AccessControl.map :require => [ :admin, :publisher, :contributor ]  do |map|
  map.permission "admin/base"
  map.permission "admin/cache"
  map.permission "admin/dashboard"
  map.permission "admin/textfilters"
  map.permission "admin/profiles"

  # FIXME: For previews, during production 'previews' is needed, during
  # test, 'articles' is needed. Proposed solution: move previews to
  # ArticlesController
  map.permission "previews"
  map.permission "articles"

  map.project_module :write, nil do |project|
    project.menu    "Write",            { :controller => "admin/content",    :action => "new" }
    project.submenu "Article",          { :controller => "admin/content",    :action => "new" }
	  project.submenu "Page",             { :controller => "admin/pages",      :action => "new" }
  end

  map.project_module :content, nil do |project|
    project.menu    "Content",           { :controller => "admin/content",    :action => "index" }
    project.submenu "Articles",         { :controller => "admin/content",    :action => "index" }
    project.submenu "Comments",         { :controller => "admin/feedback" }
	  project.submenu "Pages",            { :controller => "admin/pages",      :action => "index" }
	  project.submenu "Categories",       { :controller => "admin/categories", :action => "new" }
	  project.submenu "Files",            { :controller => "admin/resources",  :action => "index" }
	  project.submenu "Tags",             { :controller => "admin/tags",       :action => "index" }
	  project.submenu "",                      { :controller => "admin/comments", :action => "show" }
    project.submenu "",                      { :controller => "admin/comments", :action => "new" }
    project.submenu "",                      { :controller => "admin/comments", :action => "edit" }
    project.submenu "",                      { :controller => "admin/comments", :action => "destroy" }
    project.submenu "",                      { :controller => "admin/trackbacks", :action => "show" }
    project.submenu "",                      { :controller => "admin/trackbacks", :action => "new" }
    project.submenu "",                      { :controller => "admin/trackbacks", :action => "edit" }
    project.submenu "",                      { :controller => "admin/trackbacks", :action => "destroy" }
  end

  map.project_module :themes, nil do |project|
    project.menu    "Design",             { :controller => "admin/themes", :action => "index"  }
    project.submenu "Choose theme",          { :controller => "admin/themes", :action => "index" }
    project.submenu "Customize sidebar",     { :controller => "admin/sidebar", :action => "index" }
    project.submenu "Theme editor",          { :controller => "admin/themes", :action => "editor" }
    project.submenu "View theme catalogue",       { :controller => "admin/themes", :action => "catalogue" }

    AccessControl.search_plugins_directory.each do |plugin|
      project.submenu AccessControl.get_plugin_litteral_name(plugin),
        { :controller => "admin/#{AccessControl.get_plugin_controller_name(plugin)}", :action => "index" }
    end
  end

  map.project_module :settings, nil do |project|
    project.menu    "Settings",         { :controller => "admin/settings", :action => "index" }
    project.submenu "General settings", { :controller => "admin/settings", :action => "index" }
    project.submenu "Write",            { :controller => "admin/settings", :action => "write" }
    project.submenu "Feedback",         { :controller => "admin/settings", :action => "feedback" }
    project.submenu "Cache",            { :controller => "admin/cache", :action => "index" }
    project.submenu "Users",            { :controller => "admin/users", :action => "index" }
    project.submenu "Redirects",        { :controller => "admin/redirects", :action => "index" }
    project.submenu "",                 { :controller => "admin/redirects", :action => "new"}
    project.submenu "",                 { :controller => "admin/redirects", :action => "edit"}
    project.submenu "",                 { :controller => "admin/redirects", :action => "destroy"}
    project.submenu "",                 { :controller => "admin/users", :action => "show" }
    project.submenu "",                 { :controller => "admin/users", :action => "new" }
    project.submenu "",                 { :controller => "admin/users", :action => "edit" }
    project.submenu "",                 { :controller => "admin/users", :action => "destroy" }
  end

  map.project_module :seo, nil do |project|
    project.menu    "SEO",              { :controller => "admin/seo", :action => "index" }
    project.submenu "Global settings",  { :controller => "admin/seo", :action => "index" }

  end
end
