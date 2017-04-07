class PiecesController < ApplicationController
  def update
    @piece = Piece.find(params[:id])
    return unless validate_player
    success = @piece.move_to!(piece_params)
    @piece.game.update_attributes(turn: change_turn(@piece.color)) if success
    respond_to do |format|
      format.html { redirect_to game_path(@piece.game) }
      format.json { render json: @piece }
    end
  end

  private
  def change_turn(color)
    return false if color == 'white'
    true
  end

  def validate_player
    return true if current_user.id == @piece.game.white_player && @piece.game.turn
    return true if current_user.id == @piece.game.black_player && @piece.game.turn == false
    false
  end

  def piece_params
    params.require(:piece).permit(:horizontal_position, :vertical_position)
  end
end
