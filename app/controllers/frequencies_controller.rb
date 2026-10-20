class FrequenciesController < ApplicationController
  before_action :set_frequency, only: %i[ show edit update destroy ]

  # GET /frequencies or /frequencies.json
  def index
    @frequencies = Frequency.all
  end

  # GET /frequencies/1 or /frequencies/1.json
  def show
  end

  # GET /frequencies/new
  def new
    @frequency = Frequency.new
  end

  # GET /frequencies/1/edit
  def edit
  end

  # POST /frequencies or /frequencies.json
  def create
    @frequency = Frequency.new(frequency_params)

    respond_to do |format|
      if @frequency.save
        format.html { redirect_to @frequency, notice: "Frequency was successfully created." }
        format.json { render :show, status: :created, location: @frequency }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @frequency.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /frequencies/1 or /frequencies/1.json
  def update
    respond_to do |format|
      if @frequency.update(frequency_params)
        format.html { redirect_to @frequency, notice: "Frequency was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @frequency }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @frequency.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /frequencies/1 or /frequencies/1.json
  def destroy
    @frequency.destroy!

    respond_to do |format|
      format.html { redirect_to frequencies_path, notice: "Frequency was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_frequency
      @frequency = Frequency.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def frequency_params
      params.expect(frequency: [ :title, :weight ])
    end
end
