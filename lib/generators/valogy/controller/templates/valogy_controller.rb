class ValogyController < ApplicationController

  def new

  end

  def create
		uploaded_io = params[:ontology]
		if Valogy::Parser.parse(Rails.root.join('public', 'uploads', uploaded_io.original_filename))
			redirect_to root_path, notice: 'Validations successfully updated'
		else
			render action: 'new'
		end
  end

end
