require 'pac_constants'

class PreviewAttachColumnHook < Redmine::Hook::ViewListener
    SUPPORTED_CONTROLLERS = %w(IssuesController WikiController
                               MessagesController DocumentsController GanttsController
                               NewsController FilesController SysvoHelperController )

  def view_layouts_base_html_head(context={})
    #ActionController::Base::logger.info "Layouts hook controller: #{context[:controller] ? context[:controller].class.to_s : "NULL"}"
    if context[:controller] && SUPPORTED_CONTROLLERS.include?(context[:controller].class.to_s)
      str=''
      str << stylesheet_link_tag("pac_stylesheet.css", :plugin => PreviewAttachColumn::PLUGIN_NAME.to_s, :media => "screen")
      str << stylesheet_link_tag("lightbox.css", :plugin => PreviewAttachColumn::PLUGIN_NAME.to_s, :media => "screen")
      str << stylesheet_link_tag("opentip.css", :plugin => PreviewAttachColumn::PLUGIN_NAME.to_s, :media => "screen")
      #effects loaded by redmine itself
      #str << javascript_include_tag('scriptaculous.js?load=builder,effects', :plugin => 'redmine_preview_attach_column')
      str << javascript_include_tag('scriptaculous.js?load=builder', :plugin => PreviewAttachColumn::PLUGIN_NAME.to_s)
      str << javascript_include_tag('lightbox.js', :plugin => PreviewAttachColumn::PLUGIN_NAME.to_s)
      str << javascript_include_tag('opentip.js', :plugin => PreviewAttachColumn::PLUGIN_NAME.to_s)
      str << javascript_include_tag('pac.js', :plugin => PreviewAttachColumn::PLUGIN_NAME.to_s)

      str << '<script type="text/javascript">' << "\n"

      str << "LightboxOptions['fileLoadingImage']='#{PreviewAttachColumn::plugin_asset_link('images/loading.gif')}'\n"
      str << "LightboxOptions['fileBottomNavCloseImage']='#{PreviewAttachColumn::plugin_asset_link('images/closelabel.gif')}'\n"
      str << "LightboxOptions['labelImage']='#{l(:label_pac_image)}'\n"
      str << "LightboxOptions['labelOf']='#{l(:label_pac_of)}'\n"

      str << "LightboxOptions['scaleToViewport']=false\n" unless PreviewAttachColumn::settings['scale_to_screen'] == '1'
      str << "LightboxOptions['animate']=false\n" unless PreviewAttachColumn::settings['animate'] == '1'

      str << "LightboxOptions['titleAttribute']='imgdetails'\n"
      str << "LightboxOptions['scaleAttribute']='imgscale'\n"

      str << "document.observe('dom:loaded', function () { addTooltipsToAttachColumn(); });\n"

      if PreviewAttachColumn::settings['tips_enable_for_issues'] == '1'
        show_mode=PreviewAttachColumn::settings['tips_close_button'].to_i + 1
        cf=CustomField.find_by_name(PreviewAttachColumn::USER_CF_ISSUE_TOOLTIP_MODE)
        if cf
          ccf=User.current.custom_values.detect do |c|
            true if c.custom_field_id == cf.id
          end
          if ccf && ccf.value
            show_mode=$1.to_i if ccf.value =~ /^\[([0-9]+)\]/
          end
        end
        if show_mode!=0
          post_url=if Rails::VERSION::MAJOR >= 3 && Redmine::Utils::relative_url_root != ''
            "#{Redmine::Utils::relative_url_root}#{url_for({:controller => 'preview_attach_column', :action => 'get_description'})}"
          else
            url_for({:controller => 'preview_attach_column', :action => 'get_description'})
          end
          str << "document.observe('dom:loaded', function () { addTooltipsToIssues('#{post_url}','#{show_mode.to_s}','#{PreviewAttachColumn::settings['tips_show_delay']}'); });"
        end
      end

      str << "\n</script>\n"
      str.html_safe
    else
      ''
    end
  end
end


