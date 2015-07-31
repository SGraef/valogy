class ValogyController < ApplicationController

  def new

  end

  def create
		uploaded_io = params[:ontology]
		if Valogy::Translator.parse(uploaded_io.path)
			redirect_to root_path, notice: 'Validations successfully updated'
		else
			render action: 'new'
		end
  end

end
