class ErrorsController < ApplicationController
  def error_404
    notify exception
    @not_found_path = params[:not_found]
  end

  def error_500
    notify exception
  end
end
