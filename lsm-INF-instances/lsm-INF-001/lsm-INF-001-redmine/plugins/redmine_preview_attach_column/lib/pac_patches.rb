require_dependency 'query'
require_dependency 'issue'
require_dependency 'application_helper'
require_dependency 'settings_helper' if Rails::VERSION::MAJOR >= 3
require_dependency 'queries_helper'

module PreviewAttachColumn
  module Patches
    module PreviewColumnQueryPatch
      def self.included(base) # :nodoc:
        #base.extend(ClassMethods)
        base.send(:include, InstanceMethods)

        base.class_eval do
          unloadable # Send unloadable so it will not be unloaded in development
          alias_method_chain :available_columns, :preview_details
        end

      end

      module ClassMethods
      end

      module InstanceMethods

        def available_columns_with_preview_details
          return available_columns_without_preview_details if @available_columns
          available_columns_without_preview_details
          @available_columns << PreviewAttachColumn::PreviewAttachQueryColumn.new(:preview_attached, {})
          return @available_columns
        end
      end
    end

    module PreviewColumnIssuePatch
      def self.included(base) # :nodoc:

        base.send(:include, InstanceMethods)

        base.class_eval do
          unloadable # Send unloadable so it will not be unloaded in development
        end

      end

      module ClassMethods
      end

      module InstanceMethods

        def pac_field_preview_attached
          pf=PreviewAttachColumn::PreviewAttachQueryColumn.new(:preview_attached, {})
          pf.value(self)
       end
      end
    end

    module QueriesHelperPatch
      def self.included(base) # :nodoc:
        #base.extend(ClassMethods)
        base.send(:include, InstanceMethods)

        base.class_eval do
          unloadable # Send unloadable so it will not be unloaded in development
          alias_method_chain :column_content, :preview_details
        end

      end

      module ClassMethods
      end

      module InstanceMethods
        def column_content_with_preview_details(column, issue)
          if column.is_a?(PreviewAttachQueryColumn)
            str=''
            settings=PreviewAttachColumn::settings
            l(:label_pac_settings_columns_list).split('|').each do |cname|
              if settings["column_#{cname}"] == '1' && respond_to?("pac_get_content_for_#{cname}",true)
                str << send("pac_get_content_for_#{cname}",issue)
              end
            end
            str = h(" ") if str == ''
            str
          else
            column_content_without_preview_details(column,issue)
          end
        end

      end
    end

    module AttachmentsHelperPatch
      def self.included(base) # :nodoc:
        base.send(:include, InstanceMethods)

        base.class_eval do
          unloadable
          alias_method_chain :link_to_attachments, :gallery
        end
      end

      module InstanceMethods
        def link_to_attachments_with_gallery(container, options = {})
          content=link_to_attachments_without_gallery(container, options)

          if container.attachments.any?
            images = container.attachments.select { |a| a.image? }
            unless images.empty?
              content << content_tag(:div, :class => "pac-attachments-gallery") do
                str=''
                str << link_to(l(:label_pac_image_gallery),
                    {:controller => 'attachments', :action => 'download', :id => images[0], :filename => images[0].filename},
                    :rel => "lightbox[#{container.id.to_s}]", :imgdetails => pac_create_attachment_tooltip(images[0]),
                    :title => pac_create_attachment_title(:label_pac_has_images,images))
                if images.size > 1
                  str << content_tag(:div, :class => "pac-links-to-images") do
                    str1="\n".html_safe
                    images.each_with_index do |a,idx|
                      if idx > 0
                        str1 << link_to_attachment(a,:rel => "lightbox[#{container.id.to_s}]", :download => true,
                                                   :text => "0", :imgdetails => pac_create_attachment_tooltip(a)).html_safe
                        str1 << "\n".html_safe
                      end
                    end
                    str1
                  end
                end
                str.html_safe
              end
            end
          end
          content
        end
# start
#end
      end
    end

    if Rails::VERSION::MAJOR >= 3
      module ApplicationHelperPatch
        def self.included(base) # :nodoc:
          base.send(:include, InstanceMethods)

        end

        module ClassMethods
        end

        module InstanceMethods
          require_dependency File.expand_path('../../inc/pac_application_helper.rb', __FILE__)
        end

      end

      module SettingsHelperPatch
        def self.included(base) # :nodoc:
          base.send(:include, InstanceMethods)

        end

        module ClassMethods
        end

        module InstanceMethods
          require_dependency File.expand_path('../../inc/pac_settings_helper.rb', __FILE__)
        end

      end
    end
  end

  class PreviewAttachQueryColumn
    include Redmine::I18n

    attr_accessor :name, :sortable, :groupable, :default_order

    def initialize(cf_name, options={})
      @name_id=cf_name
      self.name = "pac_field_#{@name_id.to_s}".to_sym
      self.sortable=nil
      self.groupable = false
      self.default_order = 'asc'
    end

    def caption
      l("caption_pac_field_#{@name_id.to_s}")
    end

    # Returns true if the column is sortable, otherwise false
    def sortable?
      !sortable.nil?
    end

    def value(issue)
       str=''
       if issue.attachments.any?
         issue.attachments.each_with_index do |a,idx|
           str << a.filename
           str << "\n" if idx != issue.attachments.size - 1
         end
       end
       str
    end

    def css_classes
      name
    end
  end
end

unless Query.included_modules.include? PreviewAttachColumn::Patches::PreviewColumnQueryPatch
  Query.send(:include, PreviewAttachColumn::Patches::PreviewColumnQueryPatch)
end

unless Issue.included_modules.include? PreviewAttachColumn::Patches::PreviewColumnIssuePatch
  Issue.send(:include, PreviewAttachColumn::Patches::PreviewColumnIssuePatch)
end

unless QueriesHelper.included_modules.include? PreviewAttachColumn::Patches::QueriesHelperPatch
  QueriesHelper.send(:include, PreviewAttachColumn::Patches::QueriesHelperPatch)
end

unless AttachmentsHelper.included_modules.include? PreviewAttachColumn::Patches::AttachmentsHelperPatch
  AttachmentsHelper.send(:include, PreviewAttachColumn::Patches::AttachmentsHelperPatch)
end

if Rails::VERSION::MAJOR >= 3
  unless ApplicationHelper.included_modules.include? PreviewAttachColumn::Patches::ApplicationHelperPatch
    ApplicationHelper.send(:include, PreviewAttachColumn::Patches::ApplicationHelperPatch)
  end

  unless SettingsHelper.included_modules.include? PreviewAttachColumn::Patches::SettingsHelperPatch
    SettingsHelper.send(:include, PreviewAttachColumn::Patches::SettingsHelperPatch)
  end
end
