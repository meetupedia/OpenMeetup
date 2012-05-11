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

  def add_tag
    if params[:tag] and tag = Tag.find_by_permalink(params[:tag])
      current_user.tags << tag unless tag.tagging_for(current_user)
    end
    unused_tags = (@organization.tags - current_user.tags)
    @tag = unused_tags[rand(unused_tags.size)]
  end
end
