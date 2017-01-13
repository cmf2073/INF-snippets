class PreviewAttachColumnController < ApplicationController
  unloadable

  before_filter :setup_environment

  def get_description
    if @issue && @issue.visible?
      @text=if @issue.description && @issue.description.size > 0
        @issue.description
      else
        l(:label_pac_issue_no_description)
      end
      render :action => 'get_description', :layout =>false
    else
      render :text => l(:label_pac_issue_denied), :layout => false
    end
  end

protected

  def setup_environment
    @issue=Issue.find_by_id(params[:id].to_i) unless params[:id].blank?
  end

end

