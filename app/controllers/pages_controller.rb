class PagesController < ApplicationController
  layout 'rails_template'

  def index; end

  def fonts_page; end

  def spinners_page; end

  def animations_page; end

  def global_notice_page
    flash.now[:notice] = 'Here is a notice flash message!'
    flash.now[:success] = 'Here is a success flash message!'
    flash.now[:warning] = 'Here is a warning flash message!'
    flash.now[:error] = 'Here is an error flash message!'
  end

  def new
    @template_model = TemplateModel.new
  end

  def create
    @template_model = TemplateModel.new(template_model_params)
    if @template_model.save
      flash[:success] = 'Template has been created successfully.'
      redirect_to new_template_model_path
    else
      render :new
    end
  end

  def template_model_params
    params.require(:template_model).permit(:first_name, :last_name, :email, :dob, :gender, :message, :level, :active)
  end
end
