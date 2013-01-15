# encoding: UTF-8

class LetterTemplatesController < CommonController
  load_resource
  # authorize_resource

  def index
    @letter_templates = LetterTemplate.order('name ASC').paginate :page => params[:page]
  end

  def show
  end

  def new
  end

  def create
    if @letter_template.save
      redirect_to @letter_template
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @letter_template.update_attributes params[:letter_template]
      redirect_to @letter_template
    else
      render :edit
    end
  end

  def destroy
    @letter_template.destroy
    redirect_to letter_templates_url
  end

  def create_letter
    letter = Letter.create :subject => @letter_template.subject, :template => @letter_template.template
    redirect_to edit_letter_url(letter)
  end
end
