if Rails::VERSION::MAJOR >= 3
  RedmineApp::Application.routes.draw do
    match 'preview_attach_column/get_description(/:id)', :to => 'preview_attach_column#get_description', :via => :post
  end
else
  ActionController::Routing::Routes.draw do |map|
    map.with_options :controller => 'preview_attach_column' do |mfu_routes|
      mfu_routes.with_options :conditions => {:method => :post} do |mfu_views|
        mfu_views.connect 'preview_attach_column/get_description/:id', :action => 'get_description'
        mfu_views.connect 'preview_attach_column/get_description', :action => 'get_description'
      end
    end
  end
end
