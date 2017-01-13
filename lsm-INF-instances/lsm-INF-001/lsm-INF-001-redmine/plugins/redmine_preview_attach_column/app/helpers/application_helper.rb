if Redmine::VERSION::MAJOR < 2
  module ApplicationHelper

    require_dependency File.expand_path('../../../inc/pac_application_helper.rb', __FILE__)

  end
end
