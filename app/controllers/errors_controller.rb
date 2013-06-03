# encoding: UTF-8

class ErrorsController < ApplicationController

  def error_404
    render 'error_404.html', status: 404
  end
end
