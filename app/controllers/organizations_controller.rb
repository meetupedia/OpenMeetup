# -*- encoding : utf-8 -*-

class OrganizationsController < ApplicationController
  load_resource
  authorize_resource

  def show
    @title = @organization.name
  end

  def tag
    @tag = Tag.find_by_permalink params[:tag]
    @groups = @organization.groups.joins(:group_taggings => :tag).where('tags.id' => @tag.id)
  end
end
