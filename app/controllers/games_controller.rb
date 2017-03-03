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

    data = params[:p_type]

    until data.nil?
      @game.pieces.where(type: 'Pawn', vertical_position: 1).first.try(:update_attributes, type: data)
      @game.pieces.where(type: 'Pawn', vertical_position: 8).first.try(:update_attributes, type: data)
      data = params[:p_type] = nil
      redirect_to game_path(@game)
    end

    render text: 'Not Found', status: :not_found if @game.blank?
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
