module PreviewAttachColumn

  USER_CF_ISSUE_TOOLTIP_MODE = 'Description tooltips'
  PLUGIN_NAME = :redmine_preview_attach_column

  def self.settings
    Setting["plugin_#{PLUGIN_NAME.to_s}"]
  end

  def self.plugin_asset_link(asset_name,options={})
    plugin_name=(options[:plugin] ? options[:plugin].to_s : PreviewAttachColumn::PLUGIN_NAME.to_s)
    File.join(Redmine::Utils.relative_url_root,'plugin_assets',plugin_name,asset_name)
  end

end
