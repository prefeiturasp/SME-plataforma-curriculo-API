class ActivitySequencesController < ApplicationController
  before_action :set_activity_sequence, only: [:show, :update, :destroy]

  # GET /activity_sequences
  def index
    @activity_sequences = ActivitySequence.all

    render json: @activity_sequences
  end

  # GET /activity_sequences/1
  def show
    render json: @activity_sequence
  end

  # POST /activity_sequences
  def create
    @activity_sequence = ActivitySequence.new(activity_sequence_params)

    if @activity_sequence.save
      render json: @activity_sequence, status: :created, location: @activity_sequence
    else
      render json: @activity_sequence.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /activity_sequences/1
  def update
    if @activity_sequence.update(activity_sequence_params)
      render json: @activity_sequence
    else
      render json: @activity_sequence.errors, status: :unprocessable_entity
    end
  end

  # DELETE /activity_sequences/1
  def destroy
    @activity_sequence.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_activity_sequence
      @activity_sequence = ActivitySequence.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def activity_sequence_params
      params.require(:activity_sequence).permit(:title, :presentation_text, :books, :estimated_time, :status, :curricular_component_id)
    end
end
