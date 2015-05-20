class SheetsController < ApplicationController
  before_action :set_sheet, only: [:show, :edit, :update, :destroy]

  # GET /sheets
  def index
    @sheets = Sheet.all
  end

  # GET /sheets/1
  def show
  end

  # GET /sheets/new
  def new
    @sheet = Sheet.new
  end

  # GET /sheets/1/edit
  def edit
  end

  # POST /sheets
  def create
		st_params = sheet_params
		puts st_params
		if st_params[:generate_slots] == "1"
			slot =  Slot.new
			st_params.delete(:generate_slots)
		end
    @sheet = Sheet.new(st_params)
		@sheet.slots << slot if slot
    if @sheet.save
      redirect_to @sheet, notice: 'Sheet was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /sheets/1
  def update
    if @sheet.update(sheet_params)
      redirect_to @sheet, notice: 'Sheet was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /sheets/1
  def destroy
    @sheet.destroy
    redirect_to sheets_url, notice: 'Sheet was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sheet
      @sheet = Sheet.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def sheet_params
      params[:sheet].permit(:generate_slots)
    end
end
