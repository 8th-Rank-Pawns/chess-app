class GamesController < ApplicationController
  before_action :authenticate_user!, only: [:update]

  def new
    @game = Game.new
  end

  def create
    @game = Game.create(game_params.merge(white_player: current_user.id))
    @game.populate_board!
    redirect_to game_path(@game)
  end

  def show
    @game = Game.find_by_id(params[:id])
    render text: 'Not Found', status: :not_found if @game.blank?
  end

  def update
    @game = Game.find(params[:id])
    if @game.black_player.nil?
      @game.update_attributes(black_player: current_user.id)
    end
    redirect_to game_path(@game)
  end

  private

  def game_params
    params.require(:game).permit(:name)
  end
end
