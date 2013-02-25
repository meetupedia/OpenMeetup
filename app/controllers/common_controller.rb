# encoding: UTF-8

class CommonController < ApplicationController
  layout Proc.new { |p| p.request.xhr? ? false : 'application' }
  before_filter :check_for_mobile

  def ajax_request?
    request.xhr? and not request.headers['X-PJAX'] and not request.headers['X-MODAL']
  end
  helper_method :ajax_request?

  def modal_request?
    request.xhr? and request.headers['X-MODAL']
  end
  helper_method :modal_request?

  def reload_to(url)
    if request.xhr?
      render :inline => 'modalbox.reload()'
    else
      redirect_to url
    end
  end

  def redirect_to(url, options = {})
    if request.xhr?
      render :text => "window.location = '#{url_for(url)}'"
    else
      super url, options
    end
  end

  def update_page(url)
    if request.xhr?
      render :text => 'modalbox.reloadParent()'
    else
      redirect_to url
    end
  end

  def update_atom(item, options = {})
    if request.xhr?
      render 'common/update_atom', :locals => {:item => item, :options => options}
    else
      redirect_to item
    end
  end

  def update_show(item, options = {})
    if request.xhr?
      render 'common/update_show', :locals => {:item => item, :options => options}
    else
      redirect_to item
    end
  end

  def destroy_show(item, url = nil)
    if request.xhr?
      render :text => "$('##{item.class.name.underscore}_#{item.id}').fadeOut(500, function(){$('##{item.class.name.underscore}_#{item.id}').remove()});"
    else
      redirect_to url || url_for(item.class.name.tableize.to_sym)
    end
  end
end
