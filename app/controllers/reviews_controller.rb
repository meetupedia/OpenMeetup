# -*- encoding : utf-8 -*-

class ReviewsController < ApplicationController
  load_resource :group
  load_resource :review, :through => :group, :shallow => true
  authorize_resource :except => [:index, :show]

  def new
    render :layout => false if request.xhr?
  end

  def create
    @review.save
    redirect_to @review.group
  end

  def edit
  end

  def update
    @review.update_attributes params[:review]
    redirect_to @review.group, :notice => 'Értékelés módosítva.'
  end

  def destroy
    @review.destroy
    redirect_to @review.group, :notice => 'Értékelés törölve.'
  end
end
