#require_dependency 'pac_attachments_helper_extensions' unless Rails::VERSION::MAJOR >= 3

#module ApplicationHelper

#private
  def pac_create_attachment_tooltip(a)
    str =''
    str << h(a.filename)
    str << h(" - #{a.description}") unless a.description.blank?
    str << h(" (#{l(:label_pac_uploaded_by)} #{a.author}, #{format_time(a.created_on)}, #{number_to_human_size(a.filesize)})")
    str
  end

  def pac_create_attachment_title(title_sym,a_array)
    title=''
    title << "<strong>#{l(title_sym, :number => a_array.size)}</strong><br/>"
    a_array.each_with_index do |f,idx|
      title << "&nbsp;&nbsp;#{h(f.filename)}"
      title << "<br/>" unless idx== a_array.size-1
    end
    title.html_safe
  end

  def pac_create_opentip_title(title_sym)
    title=''
    title << "<strong>#{l("label_pac_tip_column_#{title_sym.to_s}")}</strong>"
    title.html_safe
  end

  def pac_get_content_for_images(issue)
    str=''
    if issue.attachments.size > 0
      images=issue.attachments.select do |a|
        true if a.image?
      end
      if images.size > 0
        str << link_to(image_tag(images.size > 1 ? 'pac_image.png' : 'pac_single_image.png', :plugin => PreviewAttachColumn::PLUGIN_NAME.to_s),
            {:controller => 'attachments', :action => 'download', :id => images[0], :filename => images[0].filename},
            :rel => "lightbox[#{issue.id.to_s}]", :imgdetails => pac_create_attachment_tooltip(images[0]),
            :opentiptitle => pac_create_attachment_title(:label_pac_has_images,images))
        if images.size > 1
          str << content_tag(:div, :class => "pac-links-to-images") do
            str1="\n"
            images.each_with_index do |a,idx|
              if idx > 0
                str1 << link_to_attachment(a,:rel => "lightbox[#{issue.id.to_s}]", :download => true,
                                           :text => "none", :imgdetails => pac_create_attachment_tooltip(a))
                str1 << "\n"
              end
            end
            str1.html_safe
          end
        end
      end
    end
    str
  end

  def pac_get_content_for_attach(issue)
    str=''
    if issue.attachments.size > 0
      images=issue.attachments.select do |a|
        true if a.image?
      end
      if issue.attachments.size != images.size
        str << link_to(image_tag('pac_attach.png', :plugin => PreviewAttachColumn::PLUGIN_NAME.to_s),
                       {:controller => 'issues', :action => 'show', :id => issue, :project_id => issue.project},
                       :opentiptitle => pac_create_attachment_title(:label_pac_has_attach,issue.attachments - images))
      end
    end
    str
  end

  def pac_get_content_for_descr(issue)
    str=''
    if issue.description && issue.description.size > 0
      str << image_tag('pac_has_descr.png', :plugin => PreviewAttachColumn::PLUGIN_NAME.to_s,
       :opentiptitle => pac_create_opentip_title(:descr))
    end
    str
  end

  def pac_get_content_for_journal(issue)
    str=''
    if issue.journals.detect { |j|	true if j.notes && j.notes.length > 0 } !=nil
      str << image_tag('pac_has_journal.png', :plugin => PreviewAttachColumn::PLUGIN_NAME.to_s,
       :opentiptitle => pac_create_opentip_title(:journal))
    end
    str
  end

  def pac_get_content_for_my(issue)
    str=''
    if issue.assigned_to == User.current
      str << image_tag('pac_has_me.png', :plugin => PreviewAttachColumn::PLUGIN_NAME.to_s,
       :opentiptitle => pac_create_opentip_title(:my))
    end
    str
  end

#end
