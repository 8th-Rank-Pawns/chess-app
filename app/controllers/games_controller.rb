class GamesController < ApplicationController
  before_action :authenticate_user!, only: [:update]

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
    if @game.blank?
      render text: 'Not Found', status: :not_found
      return
    end
    flash[:notice] = 'Black King Check!' if @game.check?('black')
    flash[:notice] = 'White King Check!' if @game.check?('white')
  end

  def update
    @game = Game.find(params[:id])
    if @game.black_player != current_user
      @game.update_attributes(black_player: current_user.id)
    end
    redirect_to game_path(@game)
  end

  private

  def game_params
    params.require(:game).permit(:name, :black_player, :white_player)
  end
end
