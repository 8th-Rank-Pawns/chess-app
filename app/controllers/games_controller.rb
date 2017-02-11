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
    @game = Game.find(params[:id])
    @game.update_attributes(player_params)
  end

  private

  def game_params
    params.require(:game).permit(:name)
  end

  def player_params
    params.require(:game).permit(:black_player)
  end
end
