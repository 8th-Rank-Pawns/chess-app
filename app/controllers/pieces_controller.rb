class PiecesController < ApplicationController
  def update
    @piece = Piece.find(params[:id])
    @piece.attempt_move(piece_params)
    render json: @piece
  end

  private

  def piece_params
    params.require(:piece).permit(:horizontal_position, :vertical_position)
  end
end
