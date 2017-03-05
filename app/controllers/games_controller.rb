class GamesController < ApplicationController
  def new
    @game = Game.new
  end

  def create
    @game = Game.create(game_params)
    @game.populate_board!
    if @game.check?(:color)
      flash[:notice] = 'Check!'
    end
    redirect_to game_path(@game)
  end

  def show
    @game = Game.find_by_id(params[:id])
    render text: 'Not Found', status: :not_found if @game.blank?
  end

  private

  def game_params
    params.require(:game).permit(:name)
  end
end
