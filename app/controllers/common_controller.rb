# encoding: UTF-8

class CommonController < ApplicationController
  layout Proc.new { |p| p.request.xhr? ? false : 'application' }
end
