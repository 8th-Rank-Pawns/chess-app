class GamesController < ApplicationController

  def new
    @game = Game.new
  end

  def create
    @game = Game.create(game_params)
    redirect_to root_path
  end

  def show
    @game = Game.find_by_id(params[:id])
    if @game.blank?
      render text: 'Not Found', status: :not_found
    end
  end
  
  private

  def game_params
    params.require(:game).permit(:name)
  end

end
