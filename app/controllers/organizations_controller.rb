# -*- encoding : utf-8 -*-

class OrganizationsController < ApplicationController
  load_resource
  authorize_resource

  def show
    @title = @organization.name
  end
end
