class PiecesController < ApplicationController
  def update
    @piece = Piece.find(params[:id])
    @piec.move_to!(piece_params)
    if @piece.game.check?(color)
      flash[:notice] = 'Check!'
    end
    respond_to do |format|
      format.html { redirect_to game_path(@piece.game) }
      format.json { render json: @piece }
    end
  end

  private

  def piece_params
    params.require(:piece).permit(:horizontal_position, :vertical_position)
  end
end
