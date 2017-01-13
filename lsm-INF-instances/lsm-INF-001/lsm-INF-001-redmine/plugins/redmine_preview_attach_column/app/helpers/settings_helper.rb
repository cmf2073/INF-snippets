if Redmine::VERSION::MAJOR < 2
  require 'pac_constants'

  module SettingsHelper

    require_dependency File.expand_path('../../../inc/pac_settings_helper.rb', __FILE__)
  end
end
