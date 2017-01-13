require 'open-uri'

module PreviewAttachColumn
  def self.unquote_string(str)
    md = str.match(/\A["']?(.*?)["']?\z/)
    md ? md[1] : str
  end
end

Redmine::WikiFormatting::Macros.register do
  desc <<-LIGHTBOX_DESCR
Displays image in lightbox-like overlay

This macro adds lightbox galleries support to wiki pages. Macro format:

*lightbox(image_name[,options])*

_image_name_ could be name of the attached file, URL or repository filename. Please do not forget to surround _image_name_ by quotes

Options are

| *Option* | *Value(s)* | *Description* |
| type | [attach,url,repo] | Explicitly defines type of the _image_name_ reference. |
| title | "Image title" | Defines link text. |
| description | "Image description" | Description displayed under image. |
| scale | [0,1] | Defines image display behavior (0-do not scale to screen, 1-scale) |
| group | symbol | Defines group id for this image. Images with similar group ids are organized in single gallery. |
| rev | number | Defines version of the file if similar files are attached (0-newest) or revision for repository entry. |
| repo_id | identifier | repository identifier if file should be fetched from different repository. |
| no_icon | 1 | Set this parameter to 1 to disable icon before link name. |

Examples

* *lightbox("new image.jpg",title="Sample image N1",description="First of two",group=1,scale=0)*
 Displays link with name _Sample image N1_. Click on link opens image attached _new image.jpg_ with description _First of two_, image not scaled to the current viewport and user can browse images whose _group_ is 1.
* *lightbox("samples/new image 2.jpg",title="Sample image N2",description="Second of two",group=1,repo_id="backup")*
 Displays link with name _Sample image N2_. Click on link opens image _samples/new image 2.jpg_ from project repository with id _backup_ and with description _First of two_, image uses default behavior for scaling and user can browse images whose _group_ is 1.
* *lightbox("http://www.example.com/sample.jpg",title="Sample image N3")*
 Displays link with name _Sample image N3_. Click on link opens image from external URL, image uses default behavior for scaling.
LIGHTBOX_DESCR
  macro :lightbox do |obj, args|
    return '' unless args.size

    options={}
    args.each_with_index do |a,idx|
      if idx > 0
        as=a.split('=')
        options[as[0].downcase.to_sym]=PreviewAttachColumn::unquote_string(as[1])
      end
    end

    image_path=PreviewAttachColumn::unquote_string(args[0])
    unless options[:type]
      if image_path.include?("://")
        options[:type]='url'
      else
        if image_path.include?("/")
          options[:type]='repo'
        else
          options[:type]='attach'
        end
      end
    else
      options[:type]=options[:type].downcase
    end

    image_title = h(options[:title] || image_path)
    rel_name = (options[:group] ? "lightbox[lb#{obj ? obj.id : "000000"}-#{options[:group]}]" : 'lightbox')

    html_options={:rel => rel_name}
    html_options[:class]=options[:no_icon] ? 'pac-link-to-gallery-no-icon' : 'pac-link-to-gallery'
    html_options[:imgscale]=h(options[:scale]) if options[:scale]
    html_options[:imgdetails]=h(options[:description]) if options[:description]

    image_url=''
    case options[:type]
      when 'url'
        image_url=link_to(image_title,image_path, html_options)
      when 'repo'
        if @project
          repo_hash={:controller => 'repositories', :id => @project, :action => 'entry', :format => 'raw', :path => image_path}
          repo_hash[:rev]=options[:rev] if options[:rev]
          repo_hash[:repository_id]=options[:repo_id] if options[:repo_id]
          image_url=link_to(image_title,repo_hash,html_options)
        end
      when 'attach'
        if obj && obj.respond_to?(:attachments)
          a=obj.attachments.find_all_by_filename(image_path)
          if a.size > 0
            a.sort! do |f1,f2|
              f2.created_on <=> f1.created_on
            end
            attach_rev=(options[:rev] || 0).to_i
            attach_rev=a.size-1 if attach_rev >= a.size
            image_url=link_to(image_title,
                {:controller => 'attachments', :action => 'download', :id => a[attach_rev].id, :filename => a[attach_rev].filename},
                  html_options)
          end
        end
      end

    image_url.html_safe
  end
end

