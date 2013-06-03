# encoding: UTF-8

class ReviewsController < CommonController
  load_resource :event
  load_resource :review, through: :event, shallow: true
  authorize_resource except: [:index, :show]

  def new
  end

  def create
    @review.event = @event
    @group = @event.group
    @review.group = @group
    if @review.save
      create_activity @review
      redirect_to @review.event
    else
      render :new
    end
  end

  def edit
  end

  def update
    @review.update_attributes params[:review]
    redirect_to @review.group, notice: 'Értékelés módosítva.'
  end

  def destroy
    @review.destroy
    redirect_to @review.group, notice: 'Értékelés törölve.'
  end
end
