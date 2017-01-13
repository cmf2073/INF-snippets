require 'redmine'
require 'dispatcher' unless Rails::VERSION::MAJOR >= 3
require 'pac_constants'

unless Redmine::Plugin.registered_plugins.keys.include?(PreviewAttachColumn::PLUGIN_NAME)
  Redmine::Plugin.register PreviewAttachColumn::PLUGIN_NAME do
    name 'Preview attached files and attributes column plugin'
    author 'Vitaly Klimov'
    author_url 'mailto:vitaly.klimov@snowbirdgames.com'
    description 'Plugin adds column from which attached files can be displayed in a lightbox manner'
    version '0.1.7'

    settings(:partial => 'settings/preview_attach_column_settings',
             :default => {
                'scale_to_screen' => '1',
                'animate' => '1',
                'tips_enable_for_issues' => '1',
                'tips_close_button' => '0',
                'tips_show_delay' => '2',
                'column_images' => '1',
                'column_attach' => '1',
                'column_descr' => '1',
                'column_journal' => '1',
                'column_my' => '1'
             })
  end

  require "pac_hooks"
  require "pac_wiki_macros"
end

if Rails::VERSION::MAJOR >= 3
  ActionDispatch::Callbacks.to_prepare do
    require 'pac_patches'
  end
else
  Dispatcher.to_prepare PreviewAttachColumn::PLUGIN_NAME do
    require_dependency 'pac_patches'
  end
end
