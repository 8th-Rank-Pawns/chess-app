class GamesController < ApplicationController
  def new
    @game = Game.new
  end

  def create
    @game = Game.create(game_params)
    @game.populate_board!
    redirect_to game_path(@game)
  end

  def show
    @game = Game.find_by_id(params[:id])
    render text: 'Not Found', status: :not_found if @game.blank?
  end

  def update
    redirect_to game_path(@game)
  end

  private

  def game_params
    params.require(:game).permit(:name)
  end

  def join
    if @game.white_id.present?
      @game.update_attributes(black_player: current_user.id)
    else
      @game.update_attribute(white_player: current_user.id)
    end
  end

end
