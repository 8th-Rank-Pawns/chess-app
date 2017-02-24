class PiecesController < ApplicationController
  def update
    @piece = Piece.find(params[:id])
    @piece.move_to!(piece_params)
    respond_to do |format|
      format.html {redirect_to game_path(@piece.game)}
      format.json {render json: @piece}
    end
  end

  private

  def piece_params
    params.require(:piece).permit(:horizontal_position, :vertical_position)
  end
end
